#!/bin/zsh

source scripts/variables.zsh

NEW_LOGS_DIR=$AUDIT_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p $NEW_LOGS_DIR

docker exec $CP_NODE_NAME sh -c 'cat /var/log/kubernetes/kube-apiserver-audit.log' > $NEW_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S').txt
docker exec $CP_NODE_NAME sh -c 'cat /var/log/kubernetes/kube-apiserver-audit.log' > $NEW_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S').json