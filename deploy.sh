#!/bin/bash

# Secure deployment script for Hugo site:
# Pulls latest changes from main, checks for updates, and runs build if changed.
# Refactored for better error handling, modularity, and safety.
# Updated to use compatible git command for getting current branch (works on Git < 2.22).

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

cd "$(dirname "$0")"

echo "Changed to directory: $(pwd)"

# Constants
MAIN_BRANCH="main"
BUILD_SCRIPT="build_site.sh"

# Function to check if in git repo
check_git_repo() {
    if [ ! -d ".git" ]; then
        echo "Error: Not in a git repository"
        exit 1
    fi
}

# Function to get current branch (compatible with older Git versions)
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Function to confirm continuation
confirm_continue() {
    local prompt="$1"
    read -p "$prompt (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deployment cancelled"
        exit 1
    fi
}

# Function to pull latest changes
pull_changes() {
    echo "Pulling latest changes from remote origin $MAIN_BRANCH..."
    git pull origin "$MAIN_BRANCH"
}

# Function to run build if changed
run_build_if_changed() {
    local old_commit="$1"
    local new_commit=$(git rev-parse HEAD)
    echo "New commit: $new_commit"

    if [ "$old_commit" != "$new_commit" ]; then
        echo "Changes detected! Running build script..."
        
        if [ -f "$BUILD_SCRIPT" ]; then
            echo "Executing $BUILD_SCRIPT..."
            chmod +x "$BUILD_SCRIPT"
            ./"$BUILD_SCRIPT"
        else
            echo "Error: $BUILD_SCRIPT not found in $(pwd)"
            exit 1
        fi
    else
        echo "No changes detected. Build script not executed."
    fi
}

# Main logic
check_git_repo

current_branch=$(get_current_branch)
echo "Current branch: $current_branch"

if [ "$current_branch" != "$MAIN_BRANCH" ]; then
    echo "Warning: Not on $MAIN_BRANCH branch. Pulling from origin $MAIN_BRANCH may affect your current branch."
    confirm_continue "Do you want to continue anyway?"
fi

old_commit=$(git rev-parse HEAD)
echo "Current commit: $old_commit"

pull_changes
run_build_if_changed "$old_commit"

echo "Deployment script completed successfully!"