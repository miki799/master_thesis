#!/bin/zsh

ROOT_DIR="$(git rev-parse --show-toplevel)"

# Kind cluster
CLUSTER_NAME=cluster
KIND_CONFIG_DIR="$ROOT_DIR/scripts/kind"
KIND_CONFIG_NAME=kind-config.yaml
KIND_CONFIG_SECURED_NAME=kind-config-secured.yaml
CP_NODE_NAME=$CLUSTER_NAME-control-plane
WORKER_NODE_NAME=$CLUSTER_NAME-worker

# Docker
DOCKER_DIR="$ROOT_DIR/src/docker"

## App

#### Users
CLUSTER_USERNAME=developer
GROUP=devs

DEV_NAMESPACE=dev
FALCO_NAMESPACE=falco

ALPINE_DEV="alpine:dev"
ALPINE_DEV_BASE_IMAGE="alpine:3.19.1"
VULN_APP="vuln_app:1.0"
VULN_APP_BASE_IMAGE="python:3"
NGINX="nginx:dev"
NGINX_BASE_IMAGE="nginx:1.26.1-alpine"
NGINX_UNPRIVILEGED="nginx:dev_unprivileged"
NGINX_UNPRIVILEGED_BASE_IMAGE="nginxinc/nginx-unprivileged:1.26.1-alpine"

## Tools
KUBESEC="kubesec:alpine"
KUBESEC_BASE_IMAGE="alpine:3.19.1"

# Kubernetes
K8S_DIR="$ROOT_DIR/src/k8s"
K8S_SEC_DIR="$ROOT_DIR/src/k8s/secured_app"
K8S_VULN_DIR="$ROOT_DIR/src/k8s/vulnerable_app"
K8S_VULNS_ATTACKS_DIR="$ROOT_DIR/src/k8s/vulns_and_attacks"

# Artifacts
USERS_DIR="$ROOT_DIR/artifacts/users"
APP_CA_DIR="$ROOT_DIR/artifacts/ca"
NGINX_DIR="$ROOT_DIR/artifacts/nginx"
LOGS_DIR="$ROOT_DIR/artifacts/logs"
KIND_LOGS_DIR=$LOGS_DIR/kind
TRIVY_LOGS_DIR=$LOGS_DIR/trivy
KUBESEC_LOGS_DIR=$LOGS_DIR/kubesec
AUDIT_LOGS_DIR=$LOGS_DIR/audit_logs