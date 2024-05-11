#!/bin/zsh

source scripts/variables.zsh
source scripts/kind/export_logs.zsh

echo "Deleting cluster $CLUSTER_NAME ..."

# Exporting logs

kind export logs --name $CLUSTER_NAME "$KIND_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')/"

# Delete cluster

kind delete cluster --name $CLUSTER_NAME
