#!/bin/zsh

alias create_cluster="./scripts/kind/create_cluster.zsh"
alias delete_cluster="./scripts/kind/delete_cluster.zsh"
alias export_cluster_logs="./scripts/kind/export_cluster_logs.zsh"
alias build_images="./scripts/docker/build_images.zsh"
alias delete_images="./scripts/docker/delete_images.zsh"
alias trivy_images_scan="./scripts/docker/trivy_images_scan.zsh"
alias deploy_app="./scripts/k8s/deploy.zsh"
alias deploy_vuln_app="./scripts/k8s/deploy_extremely_vulnerable.zsh"
alias deploy_falco="./scripts/k8s/deploy_falco.zsh"
alias kubebench_scan="./scripts/k8s/kubebench_scan.zsh"
alias kubesec_scan="./scripts/k8s/kubesec_scan.zsh"
alias clean_up="./scripts/k8s/clean_up.zsh"

