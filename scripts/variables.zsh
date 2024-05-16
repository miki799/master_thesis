#!/bin/zsh

ROOT_DIR="$(git rev-parse --show-toplevel)"

# Kind cluster
CLUSTER_NAME=master-thesis
KIND_CONFIG_DIR="$ROOT_DIR/scripts/kind"
KIND_CONFIG_NAME=kind-config.yaml
CP_NODE_NAME=$CLUSTER_NAME-control-plane
WORKER_NODE_NAME=$CLUSTER_NAME-worker

# Docker
DOCKER_DIR="$ROOT_DIR/src/docker"

## App

#### TODO: USE BASE IMAGE VARIABLES WITH DOCKER BUILDS
ALPINE_DEV="alpine:dev"
ALPINE_DEV_BASE_IMAGE="alpine:3.19.1"
VULN_APP="vuln_app:1.0"
VULN_APP_BASE_IMAGE="python:3"
ALPINE_SEC="alpine:security"
ALPINE_SEC_BASE_IMAGE="alpine:3.19.1"
NGINX="nginx:1.25.5"

## Tools
KUBESEC="kubesec/kubesec:512c5e0"

# Kubernetes
K8S_DIR="$ROOT_DIR/src/k8s"
K8S_VULN_DIR="$ROOT_DIR/src/k8s/extremely_vulnerable"

# Logs
LOGS_DIR="$ROOT_DIR/logs"
KIND_LOGS_DIR=$LOGS_DIR/kind
TRIVY_LOGS_DIR=$LOGS_DIR/trivy
KUBESEC_LOGS_DIR=$LOGS_DIR/kubesec
AUDIT_LOGS_DIR=$LOGS_DIR/audit_logs