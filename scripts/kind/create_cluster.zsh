#!/bin/zsh

source scripts/variables.zsh

echo "Creating cluster from $KIND_CONFIG_DIR/$KIND_CONFIG_NAME"

# Create cluster

kind create cluster --name $CLUSTER_NAME --config $KIND_CONFIG_DIR/$KIND_CONFIG_NAME

# Interact with cluster

kubectl cluster-info --context kind-$CLUSTER_NAME

# Install Calico

echo "Applying Calico CNI..."

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml || { echo "Failed to apply Calico manifest! Cluster cannot be created!"; exit 1; }

echo "Calico CNI applied!"

# Load Docker images

echo "Loading Docker images to the kind cluster..."

image_exists() {
    docker images "$1" &> /dev/null
}

if image_exists $VULN_APP && \
   image_exists $ALPINE_SEC && \
   image_exists $ALPINE_DEV; then
    kind load docker-image $VULN_APP $ALPINE_SEC $ALPINE_DEV --name $CLUSTER_NAME
else
    echo "One or more Docker images are not present on the local machine."
fi

# Install kube-bench on cp and worker nodes

echo "Installing kube-bench on nodes..."

docker exec $CP_NODE_NAME sh -c 'curl -LO https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_arm64.tar.gz && mkdir -p /etc/kube-bench && tar -xvf kube-bench_0.7.3_linux_arm64.tar.gz -C /etc/kube-bench && mv /etc/kube-bench/kube-bench /usr/local/bin'
docker exec $WORKER_NODE_NAME sh -c 'curl -LO https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_arm64.tar.gz && mkdir -p /etc/kube-bench && tar -xvf kube-bench_0.7.3_linux_arm64.tar.gz -C /etc/kube-bench && mv /etc/kube-bench/kube-bench /usr/local/bin'

echo "kube-bench installed!"

# Create namespaces

kubectl apply -f $K8S_DIR/namespaces.yaml

# Deploy Falco

source scripts/k8s/deploy_falco.zsh