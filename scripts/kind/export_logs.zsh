#!/bin/zsh

source scripts/variables.zsh

kind export logs --name $CLUSTER_NAME "$ROOT_DIR/logs/$(date '+%Y-%m-%d_%H-%M-%S')_logs"