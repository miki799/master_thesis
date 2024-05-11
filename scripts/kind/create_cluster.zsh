#!/bin/zsh

source scripts/variables.zsh

echo "Creating cluster from $KIND_CONFIG_DIR/$KIND_CONFIG_NAME"

# Create cluster

kind create cluster --name $CLUSTER_NAME --config $KIND_CONFIG_DIR/$KIND_CONFIG_NAME

# Interact with cluster

kubectl cluster-info --context kind-$CLUSTER_NAME

# Load Docker images

echo "Loading Docker images to the kind cluster..."

image_exists() {
    docker images "$1" &> /dev/null
}

if image_exists $VULN_APP && \
   image_exists $ALPINE_SEC && \
   image_exists $ALPINE_DEV; then
    kind load docker-image $VULN_APP $ALPINE_SEC $ALPINE_DEV --name $CLUSTER_NAME
else
    echo "One or more Docker images are not present on the local machine."
fi