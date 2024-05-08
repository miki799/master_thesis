#!/bin/zsh

DOCKER_DIR="$(git rev-parse --show-toplevel)/src/docker"

echo "Building Docker images..."

cd $DOCKER_DIR/alpine-dev && \
docker build -t alpine:dev .

cd $DOCKER_DIR/alpine-security &&
docker build -t alpine:security .

cd $DOCKER_DIR/rce-app && \
docker build -t vuln_app:1.0 .

echo "Finished building Docker images!"
