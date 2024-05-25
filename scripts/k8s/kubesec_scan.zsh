#!/bin/zsh

source scripts/variables.zsh

# kubesec

echo "Security risk analysis for K8s resources..."

NEW_LOGS_DIR=$KUBESEC_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p $NEW_LOGS_DIR
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_SEC_DIR/alpine-dev/alpine-dev.yaml > $NEW_LOGS_DIR/alpine-dev.logs
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_SEC_DIR/nginx/nginx.yaml > $NEW_LOGS_DIR/nginx.logs
docker run -i --rm $KUBESEC scan /dev/stdin < $K8S_SEC_DIR/rce-app/rce-app.yaml > $NEW_LOGS_DIR/rce-app.logs
echo "Analysis finished!"