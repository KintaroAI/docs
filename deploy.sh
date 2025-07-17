#!/bin/bash

# Exit on any error
set -e

cd "$(dirname "$0")"

echo "Changed to directory: $(pwd)"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Get the current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# Check if we're on main branch
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "Warning: Not on main branch. Current branch is: $CURRENT_BRANCH"
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deployment cancelled"
        exit 1
    fi
fi

# Store the current commit hash before pulling
OLD_COMMIT=$(git rev-parse HEAD)
echo "Current commit: $OLD_COMMIT"

# Pull the latest changes
echo "Pulling latest changes from remote..."
git pull origin main

# Get the new commit hash
NEW_COMMIT=$(git rev-parse HEAD)
echo "New commit: $NEW_COMMIT"

# Check if there were any changes
if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
    echo "Changes detected! Running build script..."
    
    # Check if build_site_run.sh exists
    if [ -f "build_site_run.sh" ]; then
        echo "Executing build_site_run.sh..."
        chmod +x build_site_run.sh
        ./build_site_run.sh
    else
        echo "Error: build_site_run.sh not found in $(pwd)"
        exit 1
    fi
else
    echo "No changes detected. Build script not executed."
fi

echo "Deployment script completed successfully!"
