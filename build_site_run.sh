#!/bin/bash
# Local builder for Hugo DocSy:
# This script builds the Hugo site using Docker, generating static files in the /public directory

echo "Starting Hugo DocSy build..."
echo "Static files will be generated in: $PWD/public"
echo ""

# Clean up any existing Hugo build lock files
if [ -f .hugo_build.lock ]; then
    echo "Removing existing Hugo build lock file..."
    rm -f .hugo_build.lock
fi

IMAGE_NAME="floryn90/hugo:ext-alpine"

# Run Hugo build
docker run --rm \
  --volume="$PWD:/src" \
  --workdir /src \
  --entrypoint sh \
  --user root:root \
  -it floryn90/hugo:ext-alpine \
  -c "apk add --no-cache nodejs npm git && git config --global --add safe.directory /src && hugo -D --minify"