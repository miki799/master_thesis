#!/bin/zsh

source scripts/variables.zsh

# kube-bench

docker exec $WORKER_NODE_NAME sh -c 'mkdir kube-bench; kube-bench run -v 5 --targets=node,policies > kube-bench/$(date '+%Y-%m-%d_%H-%M-%S')_worker.txt'

docker cp $WORKER_NODE_NAME:/kube-bench $LOGS_DIR

docker exec $CP_NODE_NAME sh -c 'mkdir kube-bench; kube-bench run -v 5 --targets=master,policies > kube-bench/$(date '+%Y-%m-%d_%H-%M-%S')_cp.txt'

docker cp $CP_NODE_NAME:/kube-bench $LOGS_DIR
