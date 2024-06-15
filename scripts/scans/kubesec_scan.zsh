#!/bin/zsh

source scripts/variables.zsh

# kubesec

echo "Security risk analysis for K8s resources..."

NEW_LOGS_DIR=$KUBESEC_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p $NEW_LOGS_DIR
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_SEC_DIR/alpine-dev/alpine-dev.yaml > $NEW_LOGS_DIR/alpine-dev_secured.logs
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_SEC_DIR/nginx/nginx.yaml > $NEW_LOGS_DIR/nginx_secured.logs
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_SEC_DIR/vuln-app/vuln-app.yaml > $NEW_LOGS_DIR/vuln-app_secured.logs
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_VULN_DIR/alpine-dev/alpine-dev.yaml > $NEW_LOGS_DIR/alpine-dev_basic.logs
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_VULN_DIR//nginx/nginx.yaml > $NEW_LOGS_DIR/nginx_basic.logs
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_VULN_DIR//vuln-app/vuln-app.yaml > $NEW_LOGS_DIR/vuln-app_basic.logs
echo "Analysis finished!"