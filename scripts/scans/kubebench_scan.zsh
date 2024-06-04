#!/bin/zsh

source scripts/variables.zsh

# kube-bench

docker exec $WORKER_NODE_NAME sh -c 'mkdir kube-bench; kube-bench run -v 5 --targets=node,policies > kube-bench/$(date '+%Y-%m-%d_%H-%M-%S')_worker.txt'

docker cp $WORKER_NODE_NAME:/kube-bench $LOGS_DIR

docker exec $CP_NODE_NAME sh -c 'mkdir kube-bench; kube-bench run -v 5 --targets=master,policies > kube-bench/$(date '+%Y-%m-%d_%H-%M-%S')_cp.txt'

docker cp $CP_NODE_NAME:/kube-bench $LOGS_DIR

# # kube-bench with job

# echo "Running kube-bench job..."
# kubectl apply -f $K8S_SEC_DIR/security-scan/kube-bench.yaml

# echo "Waiting for kube-bench job to complete..."
# kubectl wait --for=condition=complete --timeout=15s job/kube-bench -n security

# ## look for pod with completed status
# POD_NAME=$(kubectl get pods -n security --field-selector=status.phase=Succeeded -l app=kube-bench -o jsonpath='{.items[0].metadata.name}')

# if [ -n "$POD_NAME" ]; then
#   kubectl logs -n security "$POD_NAME" > "$ROOT_DIR/logs/$(date '+%Y-%m-%d_%H-%M-%S')_kube-bench-logs.txt"

#   echo "Logs retrieved from kube-bench pod: kube-bench-logs.txt"
# else
#   echo "No completed kube-bench pod found in the security namespace."
# fi