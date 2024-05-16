#!/bin/zsh

source scripts/variables.zsh

## 1 Create nginx secret (self-signed certificate)

# -x509 - This option specifies that the command should generate a self-signed certificate rather than a CSR.
# -nodes - openssl won't encrypt the key (no password)
# -days - certificate validity time
# -newkey rsa:2048 - generates RSA 2048bits private key
# -keyout - where the generated key should be saved
# -out - where the generated private key should be saved
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $K8S_DIR/nginx/nginx.key -out $K8S_DIR/nginx/nginx.crt \
-subj "/CN=localhost" -addext "subjectAltName=DNS:nginx-svc.dev.svc.cluster.local"

kubectl create secret tls nginx-secret -n dev --key=$K8S_DIR/nginx/nginx.key --cert=$K8S_DIR/nginx/nginx.crt

## 2 Deploy nginx-svc (ClusterIP, ConfigMap and Pod)

kubectl apply -f $K8S_DIR/nginx/nginx.yaml

## 3 Deploy alpine-dev

kubectl apply -f $K8S_DIR/alpine-dev/alpine-dev.yaml

## 4 Deploy vulnerable app (ClusterIP, Pod)

kubectl apply -f $K8S_DIR/rce-app/rce-app.yaml

## 5 Deploy alpine-security

# kubectl apply -f $K8S_DIR/alpine-security/alpine-security.yaml