#!/bin/zsh

#1 Create namespaces

kubectl apply -f namespaces.yaml

#2 Deploy nginx-svc service (NodePort), nginx-cm (ConfigMap) and nginx (Pod)

kubectl apply -f nginx/nginx.yaml