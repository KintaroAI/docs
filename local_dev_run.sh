#!/bin/bash
# Local dev server for Hugo DocSy:
# This script runs the Hugo development server using Docker

echo "Starting Hugo DocSy development server..."
echo "Server will be available at: http://localhost:1313"
echo "Press Ctrl+C to stop the server"
echo ""

# Clean up any existing Hugo build lock files
if [ -f .hugo_build.lock ]; then
    echo "Removing existing Hugo build lock file..."
    rm -f .hugo_build.lock
fi

IMAGE_NAME="hugo-docsy-dev"

docker build -t "$IMAGE_NAME" .

USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Run Hugo development server
docker run --rm \
  --volume="$PWD:/src" \
  --publish 1313:1313 \
  --workdir /src \
  --entrypoint sh \
  --user $USER_ID:$GROUP_ID \
  -it "$IMAGE_NAME" \
  -c "npm install && hugo server --bind 0.0.0.0 --port 1313"