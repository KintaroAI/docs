#!/bin/bash
# Secure local builder for Hugo DocSy:
# This script builds the Hugo site inside a Docker container without bind mounts.
# It creates a persistent container that clones the repo once, then reuses it for subsequent builds.
# Pulls latest changes, updates git submodules, and builds the site.
# Uses rsync for atomic update to avoid issues if serving from /public.
# Improved to stop the container after each build, starting it only when needed.
# Refactored for better error handling, modularity, and robustness.

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

cd "$(dirname "$0")"
echo "Starting secure Hugo DocSy build..."
echo "Static files will be generated in: $PWD/public"
echo ""

# Constants
IMAGE_NAME="floryn90/hugo:ext-alpine"
CONTAINER_NAME="k-hugo-builder"
REPO_URL="https://github.com/KintaroAI/docs.git"
MAX_WAIT_ATTEMPTS=30

# Clean up any existing Hugo build lock files on host (if any)
if [ -f .hugo_build.lock ]; then
    echo "Removing existing Hugo build lock file..."
    rm -f .hugo_build.lock
fi

# Function to check if container exists
container_exists() {
    docker ps -a --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"
}

# Function to check if container is running
container_running() {
    docker ps --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"
}

# Function to wait for container to start
wait_for_container() {
    echo "Waiting for container to start..."
    local attempt=0
    while [ $attempt -lt $MAX_WAIT_ATTEMPTS ]; do
        if container_running; then
            echo "Container $CONTAINER_NAME is running"
            return 0
        fi
        attempt=$((attempt + 1))
        echo "Waiting for container to start... (attempt $attempt/$MAX_WAIT_ATTEMPTS)"
        sleep 1
    done
    
    echo "Error: Container failed to start within $MAX_WAIT_ATTEMPTS seconds"
    docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}"
    docker logs $CONTAINER_NAME 2>/dev/null || echo "No container logs available"
    return 1
}

# Function to start container if not running
start_container() {
    if ! container_running; then
        echo "Starting container..."
        docker start $CONTAINER_NAME
        if ! wait_for_container; then
            exit 1
        fi
    else
        echo "Container is already running."
    fi
}

# Function to setup new container
setup_new_container() {
    echo "Persistent container does not exist. Creating new container and cloning repo..."
    
    # Create and start a new persistent container (kept alive with sleep loop)
    docker run -d --name $CONTAINER_NAME --user root:root --entrypoint sh $IMAGE_NAME -c "while true; do sleep 1; done"
    
    if ! wait_for_container; then
        exit 1
    fi
    
    # Install dependencies and clone the repo
    echo "Installing dependencies and cloning repository..."
    docker exec $CONTAINER_NAME sh -c "apk add --no-cache nodejs npm git"
    docker exec $CONTAINER_NAME sh -c "git clone $REPO_URL /src"
    docker exec $CONTAINER_NAME sh -c "cd /src && git config --global --add safe.directory /src"
}

# Function to perform the build process
perform_build() {
    echo "Pulling latest changes and building..."
    
    # Pull latest changes
    docker exec $CONTAINER_NAME sh -c "cd /src && git pull origin main"
    
    # Update git submodules
    docker exec $CONTAINER_NAME sh -c "cd /src && git submodule update --init --recursive"
    
    # Install/update npm dependencies
    docker exec $CONTAINER_NAME sh -c "cd /src && npm install"
    
    # Clean the public dir before build to remove outdated files
    docker exec $CONTAINER_NAME sh -c "rm -rf /src/public"
    
    # Build the site and check exit status
    if docker exec $CONTAINER_NAME sh -c "cd /src && hugo -D --minify"; then
        echo "Hugo build succeeded."
        sync_build_output  # Proceed to copy/rsync only on success
    else
        echo "Error: Hugo build failed. Skipping rsync."
        exit 1  # Or handle as needed (e.g., don't exit, just skip)
    fi
}

# Function to copy and sync build output
sync_build_output() {
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
}

# Trap to stop container on script exit (including errors)
trap 'echo "Stopping container on exit..."; docker stop $CONTAINER_NAME >/dev/null 2>&1 || true' EXIT

# Main logic
if ! container_exists; then
    setup_new_container
fi

start_container
perform_build

# Trap will handle stopping the container

echo "Build complete!"
echo "Note: Container '$CONTAINER_NAME' is stopped but preserved for future builds."
echo "It will be started automatically on the next build."
echo "To remove the container, run: docker rm -f $CONTAINER_NAME"