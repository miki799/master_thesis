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

deploy_basic_app() {
    ## 1 Create namespaces
    kubectl apply -f $K8S_DIR/namespaces.yaml

    ## 2 Create nginx secret (self-signed certificate)

    ### -x509 - This option specifies that the command should generate a self-signed certificate rather than a CSR.
    ### -nodes - openssl won't encrypt the key (no password)
    ### -days - certificate validity time
    ### -newkey rsa:2048 - generates RSA 2048bits private key
    ### -keyout - where the generated key should be saved
    ### -out - where the generated private key should be saved

    mkdir -p $NGINX_DIR

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $NGINX_DIR/nginx.key -out $NGINX_DIR/nginx.crt \
    -subj "/CN=localhost" -addext "subjectAltName=DNS:nginx-svc.dev.svc.cluster.local"

    kubectl create secret tls nginx-secret -n $DEV_NAMESPACE --key=$NGINX_DIR/nginx.key --cert=$NGINX_DIR/nginx.crt

    ## 3 Deploy nginx (ClusterIP, ConfigMap, Pod)

    kubectl apply -f $K8S_VULN_DIR/nginx/nginx.yaml

    ## 4 Deploy alpine-dev

    kubectl apply -f $K8S_VULN_DIR/alpine-dev/alpine-dev.yaml

    ## 5 Deploy overprivileged SA

    kubectl apply -f $K8S_VULNS_ATTACKS_DIR/overprivileged-sa.yaml

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

    ## 3 Create nginx secret (self-signed certificate)

    ### -x509 - This option specifies that the command should generate a self-signed certificate rather than a CSR.
    ### -nodes - openssl won't encrypt the key (no password)
    ### -days - certificate validity time
    ### -newkey rsa:2048 - generates RSA 2048bits private key
    ### -keyout - where the generated key should be saved
    ### -out - where the generated private key should be saved

    mkdir -p $NGINX_DIR

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $NGINX_DIR/nginx.key -out $NGINX_DIR/nginx.crt \
    -subj "/CN=localhost" -addext "subjectAltName=DNS:nginx-svc.dev.svc.cluster.local"

    kubectl create secret tls nginx-secret -n $DEV_NAMESPACE --key=$NGINX_DIR/nginx.key --cert=$NGINX_DIR/nginx.crt

    ## 4 Deploy nginx (ClusterIP, ConfigMap and Pod)

    kubectl apply -f $K8S_SEC_DIR/nginx/nginx.yaml

    ## 5 Deploy alpine-dev

    kubectl apply -f $K8S_SEC_DIR/alpine-dev/alpine-dev.yaml

    ## 6 Deploy vulnerable app (ClusterIP, Pod)

    kubectl apply -f $K8S_SEC_DIR/vuln-app/vuln-app.yaml

    ## 7 Deploy NetworkPolicy resources

    kubectl apply -f $K8S_SEC_DIR/network-policies/dev-restrict-traffic.yaml
    kubectl apply -f $K8S_SEC_DIR/network-policies/default-deny-traffic.yaml

    ## 8 Deploy Falco

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
