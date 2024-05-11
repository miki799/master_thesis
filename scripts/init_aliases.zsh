#!/bin/zsh

alias create_cluster="./scripts/kind/create_cluster.zsh"
alias delete_cluster="./scripts/kind/delete_cluster.zsh"
alias export_cluster_logs="./scripts/kind/export_cluster_logs.zsh"
alias build_images="./scripts/docker/build_images.zsh"
alias delete_images="./scripts/docker/delete_images.zsh"
alias scan_images="./scripts/docker/scan_images.zsh"
alias deploy_app="./scripts/k8s/deploy.zsh"
alias deploy_vuln_app="./scripts/k8s/deploy_extremely_vulnerable.zsh"
alias scan_cluster="./scripts/k8s/scan_cluster.zsh"
alias scan_manifests="./scripts/k8s/scan_manifests.zsh"
alias clean_up="./scripts/k8s/clean_up.zsh"

