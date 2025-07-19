#!/bin/bash
# Secure local builder for Hugo DocSy:
# This script builds the Hugo site inside a Docker container without bind mounts.
# It creates a persistent container that clones the repo once, then reuses it for subsequent builds.
# Uses rsync for atomic update to avoid issues if serving from /public.

cd "$(dirname "$0")"
echo "Starting secure Hugo DocSy build..."
echo "Static files will be generated in: $PWD/public"
echo ""

# Clean up any existing Hugo build lock files on host (if any)
if [ -f .hugo_build.lock ]; then
    echo "Removing existing Hugo build lock file..."
    rm -f .hugo_build.lock
fi

IMAGE_NAME="floryn90/hugo:ext-alpine"
CONTAINER_NAME="hugo-build-persistent"
REPO_URL="https://github.com/KintaroAI/docs.git"

# Function to perform the build process
perform_build() {
    echo "Pulling latest changes and building..."
    
    # Pull latest changes
    docker exec $CONTAINER_NAME sh -c "cd /src && git pull origin main"
    
    # Install/update npm dependencies
    docker exec $CONTAINER_NAME sh -c "cd /src && npm install"
    
    # Build the site
    docker exec $CONTAINER_NAME sh -c "cd /src && hugo -D --minify"
}

# Function to wait for container to start
wait_for_container() {
    echo "Waiting for container to start..."
    MAX_ATTEMPTS=30
    ATTEMPT=0
    while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
        if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "^$CONTAINER_NAME.*Up"; then
            echo "Container $CONTAINER_NAME is running"
            return 0
        fi
        ATTEMPT=$((ATTEMPT + 1))
        echo "Waiting for container to start... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
        sleep 1
    done
    
    echo "Error: Container failed to start within $MAX_ATTEMPTS seconds"
    echo "Container status:"
    docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.State}}"
    docker logs $CONTAINER_NAME 2>/dev/null || echo "No container logs available"
    return 1
}

# Check if the persistent container does NOT exist
if ! docker ps -a --format "table {{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
    echo "Persistent container does not exist. Creating new container and cloning repo..."
    
    # Create and start a new persistent container
    docker run -d --name $CONTAINER_NAME --user root:root --entrypoint sh $IMAGE_NAME -c "while true; do sleep 1; done"
    
    # Wait for the container to start
    if ! wait_for_container; then
        exit 1
    fi
    
    # Small delay to ensure container is fully ready
    sleep 2
    
    # Install dependencies and clone the repo
    echo "Installing dependencies and cloning repository..."
    docker exec $CONTAINER_NAME sh -c "apk add --no-cache nodejs npm git"
    docker exec $CONTAINER_NAME sh -c "git clone $REPO_URL /src"
    docker exec $CONTAINER_NAME sh -c "cd /src && git config --global --add safe.directory /src"
fi

# Check if container is NOT running
if ! docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "^$CONTAINER_NAME.*Up"; then
    echo "Container exists but not running. Starting it..."
    docker start $CONTAINER_NAME
    
    # Wait for container to start
    if ! wait_for_container; then
        exit 1
    fi
else
    echo "Container is running."
fi

perform_build

# Clean up existing public-temp on host if it exists
rm -rf ./public-temp

# Copy only the /public folder back to a temp dir on host
echo "Copying built public folder to temp dir..."
docker cp $CONTAINER_NAME:/src/public ./public-temp

# Sync temp to live public using rsync with delete
echo "Syncing temp to public (atomic update)..."
rsync -a --delete ./public-temp/ ./public/

# Remove the temp dir
rm -rf ./public-temp

echo "Build complete!"
echo "Note: Container '$CONTAINER_NAME' is kept running for future builds."
echo "To remove the container, run: docker rm -f $CONTAINER_NAME"