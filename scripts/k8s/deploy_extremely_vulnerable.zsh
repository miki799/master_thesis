#!/bin/zsh

source scripts/variables.zsh

## 1 Create namespaces

kubectl apply -f $K8S_DIR/namespaces.yaml

## 2 Deploy nginx (ClusterIP, ConfigMap, Pod)

kubectl apply -f $K8S_VULN_DIR/nginx/nginx.yaml

## 3 Deploy alpine-dev

kubectl apply -f $K8S_VULN_DIR/alpine-dev/alpine-dev.yaml

## 4 Deploy vulnerable app (ClusterIP, Pod)

kubectl apply -f $K8S_VULN_DIR/rce-app/rce-app.yaml

## 5 Deploy alpine-security

kubectl apply -f $K8S_VULN_DIR/alpine-security/alpine-security.yaml