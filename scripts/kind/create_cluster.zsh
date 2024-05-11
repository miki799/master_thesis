#!/bin/zsh

source scripts/variables.zsh

echo "Creating cluster from $KIND_CONFIG_DIR/$KIND_CONFIG_NAME"

# Create cluster

kind create cluster --name $CLUSTER_NAME --config $KIND_CONFIG_DIR/$KIND_CONFIG_NAME

# Interact with cluster

kubectl cluster-info --context kind-$CLUSTER_NAME
