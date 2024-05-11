#!/bin/zsh

source scripts/variables.zsh

echo "Deleting cluster $CLUSTER_NAME ..."

# Exporting logs

kind export logs --name $CLUSTER_NAME "$ROOT_DIR/logs/$(date '+%Y-%m-%d_%H-%M-%S')_logs"

# Delete cluster

kind delete cluster --name $CLUSTER_NAME
