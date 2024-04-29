#!/bin/zsh

#1 Delete namespaces with resources

echo "Deleting namespaces..."

kubectl delete ns dev
kubectl delete ns sec-monitor

echo "Namespaces deleted!"

#2 Delete certs and keys

echo "Deleting certs and keys..."

rm -f /nginx/nginx.crt
rm -f /nginx/nginx.key

echo "Certs and keys deleted!"
