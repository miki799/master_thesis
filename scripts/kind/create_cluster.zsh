#!/bin/zsh

source scripts/variables.zsh

SELECTED_CONFIG=$KIND_CONFIG_NAME

display_help() {
  echo "Usage: $0 [OPTION] [secured | basic]"
  echo ""
  echo "This script creates a Kubernetes cluster using kind."
  echo "Arguments:"
  echo "basic - creates basic cluster"
  echo "secured - creates cluster with enabled audit-policies, configured Pod Security Standards and enabled encryption of data at rest"
  echo "Options:"
  echo "  -h, --help      Display this help message and exit"
  echo ""
}

if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  display_help
  exit 0
fi

if [ "$1" = "secured" ]; then
    SELECTED_CONFIG=$KIND_CONFIG_SECURED_NAME
    echo "Secured cluster will be created!"
elif [ "$1" = "basic" ]; then
    echo "Basic cluster will be created!"
else
    echo "Incorrect arguments provided!"
    display_help
    exit 1
fi

# Create cluster

echo "Creating cluster from $KIND_CONFIG_DIR/$SELECTED_CONFIG"
kind create cluster --name $CLUSTER_NAME --config $KIND_CONFIG_DIR/$SELECTED_CONFIG

# Interact with cluster

kubectl cluster-info --context kind-$CLUSTER_NAME

# Install Calico (needed for NetworkPolicies, kind Kindnet CNI doesn't support them)

echo "Applying Calico CNI..."

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml || { echo "Failed to apply Calico manifest! Cluster cannot be created!"; exit 1; }

echo "Calico CNI applied!"

# Load Docker images

echo "Loading Docker images to the kind cluster..."

image_exists() {
    docker images "$1" &> /dev/null
}

if image_exists $VULN_APP && \
   image_exists $ALPINE_DEV; then
    kind load docker-image $VULN_APP $ALPINE_DEV --name $CLUSTER_NAME
else
    echo "One or more Docker images are not present on the local machine."
fi

# Install kube-bench on cp and worker nodes

echo "Installing kube-bench on nodes..."

docker exec $CP_NODE_NAME sh -c 'curl -LO https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_arm64.tar.gz && mkdir -p /etc/kube-bench && tar -xvf kube-bench_0.7.3_linux_arm64.tar.gz -C /etc/kube-bench && mv /etc/kube-bench/kube-bench /usr/local/bin'
docker exec $WORKER_NODE_NAME sh -c 'curl -LO https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_arm64.tar.gz && mkdir -p /etc/kube-bench && tar -xvf kube-bench_0.7.3_linux_arm64.tar.gz -C /etc/kube-bench && mv /etc/kube-bench/kube-bench /usr/local/bin'

echo "kube-bench installed!"