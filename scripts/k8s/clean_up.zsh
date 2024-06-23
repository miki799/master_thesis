#!/bin/zsh

source scripts/variables.zsh

## 1 Delete namespaces with resources

echo "Deleting namespaces..."

kubectl delete namespace $DEV_NAMESPACE
kubectl delete namespace $FALCO_NAMESPACE

echo "Namespaces deleted!"

## 2 Delete certs and keys

echo "Deleting certs and keys..."

rm -rf $USERS_DIR
rm -rf $NGINX_DIR

echo "Certs and keys deleted!"

## 3 Delete users

source scripts/k8s/users.zsh --delete