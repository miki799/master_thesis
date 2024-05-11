#!/bin/zsh

source scripts/variables.zsh

kind export logs --name $CLUSTER_NAME "$KIND_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')/"