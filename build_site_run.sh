#!/bin/bash
# Secure local builder for Hugo DocSy:
# This script builds the Hugo site inside a Docker container without bind mounts.
# It copies site files into the container, performs the build, and copies only the /public folder back to the host via a temp folder.
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
CONTAINER_NAME="hugo-build-temp"

# Stop and remove any existing container with the same name
docker rm -f $CONTAINER_NAME > /dev/null 2>&1

# Create and start a temporary container in detached mode
docker run -d --name $CONTAINER_NAME --user root:root --entrypoint sh $IMAGE_NAME -c "while true; do sleep 1; done"

# Wait for the container to start
echo "Waiting for container to start..."
MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "^$CONTAINER_NAME.*Up"; then
        echo "Container $CONTAINER_NAME is running"
        break
    fi
    ATTEMPT=$((ATTEMPT + 1))
    echo "Waiting for container to start... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
    sleep 1
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo "Error: Container failed to start within $MAX_ATTEMPTS seconds"
    echo "Container status:"
    docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.State}}"
    docker logs $CONTAINER_NAME 2>/dev/null || echo "No container logs available"
    exit 1
fi

# Small delay to ensure container is fully ready
sleep 2

# Copy the current directory (site files) into the container
echo "Copying site files into the container..."
docker cp . $CONTAINER_NAME:/src

# Check if container is still running before executing commands
if ! docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "^$CONTAINER_NAME.*Up"; then
    echo "Error: Container $CONTAINER_NAME is not running anymore"
    echo "Container status:"
    docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.State}}"
    echo "Container logs:"
    docker logs $CONTAINER_NAME 2>/dev/null || echo "No container logs available"
    exit 1
fi

# Execute the build commands inside the container
echo "Building the site inside the container..."
docker exec $CONTAINER_NAME sh -c "apk add --no-cache nodejs npm git && git config --global --add safe.directory /src && hugo -D --minify"

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

# Clean up: Stop and remove the container
docker rm -f $CONTAINER_NAME > /dev/null 2>&1

echo "Build complete!"