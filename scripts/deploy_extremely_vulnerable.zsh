#!/bin/zsh

K8S_DIR="$(git rev-parse --show-toplevel)/src/k8s"
K8S_VULN_DIR="$(git rev-parse --show-toplevel)/src/k8s/extremely_vulnerable"

#1 Create namespaces

kubectl apply -f $K8S_DIR/namespaces.yaml

#2 Deploy nginx-svc service (NodePort), nginx-cm (ConfigMap) and nginx (Pod)

kubectl apply -f $K8S_VULN_DIR/nginx/nginx.yaml

#3 Deploy alpine-dev

kubectl apply -f $K8S_VULN_DIR/alpine-dev/alpine-dev.yaml

#4 Deploy vulnerable app

kubectl apply -f $K8S_VULN_DIR/rce-app/rce-app.yaml

#4 Deploy alpine-security

kubectl apply -f $K8S_VULN_DIR/alpine-security/alpine-security.yaml