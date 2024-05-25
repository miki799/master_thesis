#!/bin/zsh

source scripts/variables.zsh

## 1 Create namespaces

kubectl apply -f $K8S_SEC_DIR/namespaces.yaml

## 2 Create nginx secret (self-signed certificate)

# -x509 - This option specifies that the command should generate a self-signed certificate rather than a CSR.
# -nodes - openssl won't encrypt the key (no password)
# -days - certificate validity time
# -newkey rsa:2048 - generates RSA 2048bits private key
# -keyout - where the generated key should be saved
# -out - where the generated private key should be saved

mkdir -p $NGINX_DIR

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $NGINX_DIR/nginx.key -out $NGINX_DIR/nginx.crt \
-subj "/CN=localhost" -addext "subjectAltName=DNS:nginx-svc.dev.svc.cluster.local"

kubectl create secret tls nginx-secret -n $DEV_NAMESPACE --key=$NGINX_DIR/nginx.key --cert=$NGINX_DIR/nginx.crt

## 3 Deploy nginx-svc (ClusterIP, ConfigMap and Pod)

kubectl apply -f $K8S_SEC_DIR/nginx/nginx.yaml

## 4 Deploy alpine-dev

kubectl apply -f $K8S_SEC_DIR/alpine-dev/alpine-dev.yaml

## 5 Deploy vulnerable app (ClusterIP, Pod)

kubectl apply -f $K8S_SEC_DIR/rce-app/rce-app.yaml

## 6 Deploy NetworkPolicy resources

kubectl apply -f $K8S_SEC_DIR/network-policies/dev-restrict-traffic.yaml
kubectl apply -f $K8S_SEC_DIR/network-policies/default-deny-traffic.yaml

## 7 Configure RBAC

### devs group access control

kubectl apply -f $K8S_SEC_DIR/rbac/devs.yaml

## 8 Deploy Falco

source scripts/k8s/deploy_falco.zsh