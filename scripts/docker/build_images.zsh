#!/bin/zsh

source scripts/variables.zsh

echo "Building Docker images..."

cd $DOCKER_DIR/alpine-dev && \
docker build -t $ALPINE_DEV .

cd $DOCKER_DIR/alpine-security &&
docker build -t $ALPINE_SEC .

cd $DOCKER_DIR/rce-app && \
docker build -t $VULN_APP .

echo "Finished building Docker images!"

echo "Loading Docker images to the kind cluster..."

if kubectl get node $CP_NODE_NAME &> /dev/null; then
    kind load docker-image $VULN_APP $ALPINE_SEC $ALPINE_DEV --name $CLUSTER_NAME
    echo "Finished!"
else
    echo "$CP_NODE_NAME node does not exist!"
fi
