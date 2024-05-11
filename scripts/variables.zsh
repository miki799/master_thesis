#!/bin/zsh

ROOT_DIR="$(git rev-parse --show-toplevel)"

# Kind cluster
CLUSTER_NAME=master-thesis
KIND_CONFIG_DIR="$ROOT_DIR/scripts/kind"
KIND_CONFIG_NAME=kind-config.yaml
CP_NODE_NAME=$CLUSTER_NAME-control-plane

# Docker
DOCKER_DIR="$ROOT_DIR/src/docker"
NGINX="nginx:dev"
ALPINE_DEV="alpine:dev"
VULN_APP="vuln_app:1.0"
ALPINE_SEC="alpine:security"

# Kubernetes
K8S_DIR="$ROOT_DIR/src/k8s"
K8S_VULN_DIR="$ROOT_DIR/src/k8s/extremely_vulnerable"