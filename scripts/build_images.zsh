#!/bin/zsh

echo "Building Docker images..."

docker build -t alpine:dev -f alpine-dev/.dockerfile .

docker build -t alpine:sec-monitor -f alpine-sec-monitor/.dockerfile .

echo "Finished building Docker images!"
