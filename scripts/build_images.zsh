#!/bin/zsh

source scripts/variables.zsh

echo "Building Docker images..."

cd $DOCKER_DIR/alpine-dev && \
docker build -t alpine:dev .

cd $DOCKER_DIR/alpine-security &&
docker build -t alpine:security .

cd $DOCKER_DIR/rce-app && \
docker build -t vuln_app:1.0 .

echo "Finished building Docker images!"

echo "Loading Docker images to the kind cluster..."

if kubectl get node $CP_NODE_NAME &> /dev/null; then
    kind load docker-image vuln_app:1.0 alpine:security alpine:dev --name $CLUSTER_NAME
    echo "Finished!"
else
    echo "$CP_NODE_NAME node does not exist"
fi
