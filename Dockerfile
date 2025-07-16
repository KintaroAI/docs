FROM floryn90/hugo:ext-alpine

USER root

# Install Node.js, npm, git and configure git
RUN apk add --no-cache nodejs npm git

RUN git config --global --add safe.directory /src


WORKDIR /src