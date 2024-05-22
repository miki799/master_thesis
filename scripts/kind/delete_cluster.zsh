#!/bin/zsh

source scripts/variables.zsh

echo "Deleting cluster $CLUSTER_NAME ..."

# Exporting logs

kind export logs --name $CLUSTER_NAME "$KIND_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')/"

# Delete cluster

kind delete cluster --name $CLUSTER_NAME

# Delete certs and keys

echo "Deleting certs and keys..."

rm -rf $USERS_DIR
rm -rf $NGINX_DIR

echo "Certs and keys deleted!"