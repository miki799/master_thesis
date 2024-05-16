#!/bin/zsh

source scripts/variables.zsh

## 1 Delete namespaces with resources

echo "Deleting namespaces..."

kubectl delete ns dev
kubectl delete ns security

echo "Namespaces deleted!"

## 2 Delete certs and keys

echo "Deleting certs and keys..."

rm -f $K8S_DIR/nginx/nginx.crt
rm -f $K8S_DIR/nginx/nginx.key

echo "Certs and keys deleted!"