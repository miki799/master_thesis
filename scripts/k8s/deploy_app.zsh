#!/bin/zsh

source scripts/variables.zsh

display_help() {
  echo "Usage: $0 [OPTION] [secured | basic]"
  echo ""
  echo "This script deploys app."
  echo "Arguments:"
  echo "basic - deploys basic app without security mechanisms like RBAC, NetworkPolicy, securityContexxt"
  echo "secured - deploys fully secured app."
  echo "Options:"
  echo "  -h, --help      Display this help message and exit"
  echo ""
}

create_certificates_and_secrets() {
    mkdir -p $APP_CA_DIR
    mkdir -p $NGINX_DIR

    # Create App CA and k8s Secret called ca-secret

    openssl genrsa -out $APP_CA_DIR/ca.key 2048

    openssl req -x509 -new -nodes -key $APP_CA_DIR/ca.key -sha256 -days 365 -out $APP_CA_DIR/ca.crt -subj "/C=PL/ST=MPL/L=KRK/O=PK/CN=TelecCA"

    kubectl create secret generic ca-secret -n $DEV_NAMESPACE --from-file=cert=$APP_CA_DIR/ca.crt

    ## Create nginx certificate, private key and k8s Secret called nginx-secret

    openssl genrsa -out $NGINX_DIR/nginx.key 2048

    openssl req -new -key $NGINX_DIR/nginx.key -out $NGINX_DIR/nginx.csr \
    -subj "/CN=nginx-svc.dev.svc.cluster.local" \
    -addext "subjectAltName=DNS:localhost,DNS:nginx-svc.dev.svc.cluster.local"

    openssl x509 -req -in $NGINX_DIR/nginx.csr -CA $APP_CA_DIR/ca.crt -CAkey $APP_CA_DIR/ca.key -out $NGINX_DIR/nginx.crt -days 365 -sha256

    kubectl create secret tls nginx-secret -n $DEV_NAMESPACE --key=$NGINX_DIR/nginx.key --cert=$NGINX_DIR/nginx.crt
}

deploy_basic_app() {
    ## 1 Create namespaces
    kubectl apply -f $K8S_DIR/namespaces.yaml

    ## 2 Create ca and secrets

    create_certificates_and_secrets

    ## 4 Deploy nginx (ClusterIP, ConfigMap, Pod)

    kubectl apply -f $K8S_VULN_DIR/nginx/nginx.yaml

    ## 5 Deploy alpine-dev

    kubectl apply -f $K8S_VULN_DIR/alpine-dev/alpine-dev.yaml

    ## 6 Deploy vulnerable app (ClusterIP, Pod)

    kubectl apply -f $K8S_VULN_DIR/vuln-app/vuln-app.yaml

    ## 7 Deploy Falco

    source scripts/k8s/deploy_falco.zsh
}

deploy_secured_app() {
    ## 1 Create namespaces

    kubectl apply -f $K8S_DIR/namespaces.yaml

    ## 2 Configure RBAC

    ### devs group
    kubectl apply -f $K8S_SEC_DIR/rbac/devs-role.yaml

    ### pod-viewers group
    # kubectl apply -f $K8S_SEC_DIR/rbac/pod-viewers-role.yaml

    ### default SA
    kubectl apply -f $K8S_SEC_DIR/rbac/default-sa.yaml

    ## 3 Create ca certificate and ca-secret secret

    mkdir -p $APP_CA_DIR
    mkdir -p $NGINX_DIR

    openssl genrsa -out $APP_CA_DIR/ca.key 2048

    openssl req -x509 -new -nodes -key $APP_CA_DIR/ca.key -sha256 -days 365 -out $APP_CA_DIR/ca.crt -subj "/C=PL/ST=MPL/L=KRK/O=PK/CN=TelecCA"

    kubectl create secret generic ca-secret -n $DEV_NAMESPACE --from-file=cert=$APP_CA_DIR/ca.crt

    ## 4 Create nginx certificate and nginx-secret

    openssl genrsa -out $NGINX_DIR/nginx.key 2048

    openssl req -new -key $NGINX_DIR/nginx.key -out $NGINX_DIR/nginx.csr \
    -subj "/CN=nginx-svc.dev.svc.cluster.local" \
    -addext "subjectAltName=DNS:localhost,DNS:nginx-svc.dev.svc.cluster.local"

    openssl x509 -req -in $NGINX_DIR/nginx.csr -CA $APP_CA_DIR/ca.crt -CAkey $APP_CA_DIR/ca.key -out $NGINX_DIR/nginx.crt -days 365 -sha256

    kubectl create secret tls nginx-secret -n $DEV_NAMESPACE --key=$NGINX_DIR/nginx.key --cert=$NGINX_DIR/nginx.crt

    ## 5 Deploy nginx (ClusterIP, ConfigMap and Pod)

    kubectl apply -f $K8S_SEC_DIR/nginx/nginx.yaml

    ## 6 Deploy alpine-dev

    kubectl apply -f $K8S_SEC_DIR/alpine-dev/alpine-dev.yaml

    ## 7 Deploy vulnerable app (ClusterIP, Pod)

    kubectl apply -f $K8S_SEC_DIR/vuln-app/vuln-app.yaml

    ## 8 Deploy NetworkPolicy resources

    kubectl apply -f $K8S_SEC_DIR/network-policies/dev-restrict-traffic.yaml
    kubectl apply -f $K8S_SEC_DIR/network-policies/default-deny-traffic.yaml

    ## 9 Deploy Falco

    source scripts/k8s/deploy_falco.zsh
}

if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  display_help
  exit 0
fi

if [ "$1" = "secured" ]; then
    echo "Secured app will be deployed"
    deploy_secured_app
elif [ "$1" = "basic" ]; then
    echo "Basic app will be deployed"
    deploy_basic_app
else
    echo "Incorrect arguments provided!"
    display_help
    exit 1
fi
