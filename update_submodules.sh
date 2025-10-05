#!/bin/bash

# Script to update git submodules with proper change detection and commit handling
# Checks for uncommitted changes, updates submodules, and commits changes if needed

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

cd "$(dirname "$0")"

echo "Checking for uncommitted changes in main repository..."

# Check if there are uncommitted changes in the main repository
if ! git diff-index --quiet HEAD --; then
    echo "Error: There are uncommitted changes in the main repository."
    echo "Please commit or stash your changes before updating submodules."
    echo ""
    echo "Uncommitted changes:"
    git status --porcelain
    exit 1
fi

echo "No uncommitted changes found. Proceeding with submodule update..."

# Update submodules
echo "Updating submodules..."
git submodule update --remote --merge

# Check if submodules were actually updated
if ! git diff-index --quiet HEAD --; then
    echo "Submodules were updated. Committing changes..."
    git add .
    git commit -m "Updated submodules dependencies"
    echo "Changes committed successfully."
else
    echo "No submodule updates found."
fi

echo "Submodule update completed successfully!"