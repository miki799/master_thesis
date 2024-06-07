#!/bin/zsh

source scripts/variables.zsh

## 1 Create namespaces

kubectl apply -f $K8S_VULN_DIR/namespaces.yaml

## 2 Deploy nginx (ClusterIP, ConfigMap, Pod)

kubectl apply -f $K8S_VULN_DIR/nginx/nginx.yaml

## 3 Deploy alpine-dev

kubectl apply -f $K8S_VULN_DIR/alpine-dev/alpine-dev.yaml

## 4 Deploy overprivileged SA

kubectl apply -f $K8S_VULNS_ATTACKS_DIR/overprivileged-sa.yaml

## 5 Deploy vulnerable app (ClusterIP, NodePort Pod)

kubectl apply -f $K8S_VULN_DIR/vuln-app/vuln-app.yaml

kubectl apply -f $K8S_VULNS_ATTACKS_DIR/vuln-app-nodeport.yaml