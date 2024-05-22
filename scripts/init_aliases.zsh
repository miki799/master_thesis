#!/bin/zsh

alias create_cluster="./scripts/kind/create_cluster.zsh"
alias delete_cluster="./scripts/kind/delete_cluster.zsh"
alias export_cluster_logs="./scripts/kind/export_cluster_logs.zsh"
alias export_audit_logs="./scripts/k8s/export_audit_logs.zsh"
alias create_users="./scripts/k8s/create_users.zsh"
alias build_images="./scripts/docker/build_images.zsh"
alias delete_images="./scripts/docker/delete_images.zsh"
alias trivy_images_scan="./scripts/docker/trivy_images_scan.zsh"
alias deploy_app="./scripts/k8s/deploy_app.zsh"
alias deploy_vuln_app="./scripts/k8s/deploy_vuln_app.zsh"
alias deploy_falco="./scripts/k8s/deploy_falco.zsh"
alias kubebench_scan="./scripts/k8s/kubebench_scan.zsh"
alias kubesec_scan="./scripts/k8s/kubesec_scan.zsh"
alias clean_up="./scripts/k8s/clean_up.zsh"

