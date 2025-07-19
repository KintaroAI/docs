#!/bin/bash

# Script to run an Nginx Docker container serving local public directory.
# Refactored for better error handling, modularity, and robustness.
# Ensures existing container (running or stopped) is removed before starting a new one.

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

cd "$(dirname "$0")"

# Constants
IMAGE_NAME="nginx"
CONTAINER_NAME="k-nginx"
HOST_PORT=8080
CONTAINER_PORT=80
VOLUME_PATH="$(pwd)/public:/usr/share/nginx/html"

# Function to check if container exists (running or stopped)
container_exists() {
    [ -n "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]
}

# Function to remove existing container if it exists
remove_existing_container() {
    if container_exists; then
        echo "Existing container ${CONTAINER_NAME} found. Stopping and removing it..."
        docker rm -f "${CONTAINER_NAME}"
    else
        echo "No existing container ${CONTAINER_NAME} found."
    fi
}

# Function to run the new container
run_container() {
    echo "Starting new container ${CONTAINER_NAME}..."
    docker run \
        --name "${CONTAINER_NAME}" \
        --volume="${VOLUME_PATH}" \
        -d \
        --restart always \
        -p "${HOST_PORT}:${CONTAINER_PORT}" \
        "${IMAGE_NAME}"
    echo "Container ${CONTAINER_NAME} started successfully on port ${HOST_PORT}."
}

# Main logic
remove_existing_container
run_container

echo "Script completed successfully!"