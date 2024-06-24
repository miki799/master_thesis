#!/bin/zsh

source scripts/variables.zsh

# kubesec

CONTAINER_NAME="kubesec_scanner"
NEW_LOGS_DIR=$KUBESEC_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')

echo "Security risk analysis for K8s resources..."

mkdir -p $NEW_LOGS_DIR

docker run --name $CONTAINER_NAME -dit $KUBESEC /bin/sh

# Secured pods

docker cp $K8S_SEC_DIR/alpine-dev/alpine-dev.yaml $CONTAINER_NAME:/alpine-dev.yaml
docker cp $K8S_SEC_DIR/nginx/nginx.yaml $CONTAINER_NAME:/nginx.yaml
docker cp $K8S_SEC_DIR/vuln-app/vuln-app.yaml $CONTAINER_NAME:/vuln-app.yaml

docker exec $CONTAINER_NAME kubesec scan alpine-dev.yaml > $NEW_LOGS_DIR/alpine-dev.logs
docker exec $CONTAINER_NAME kubesec scan nginx.yaml > $NEW_LOGS_DIR/nginx.logs
docker exec $CONTAINER_NAME kubesec scan vuln-app.yaml > $NEW_LOGS_DIR/vuln-app.logs

# Vulnerable pods

docker cp  $K8S_VULN_DIR/alpine-dev/alpine-dev.yaml $CONTAINER_NAME:/alpine-dev.yaml
docker cp  $K8S_VULN_DIR/nginx/nginx.yaml $CONTAINER_NAME:/nginx.yaml
docker cp  $K8S_VULN_DIR/vuln-app/vuln-app.yaml $CONTAINER_NAME:/vuln-app.yaml

docker exec $CONTAINER_NAME kubesec scan alpine-dev.yaml > $NEW_LOGS_DIR/alpine-dev_vulnerable.logs
docker exec $CONTAINER_NAME kubesec scan nginx.yaml > $NEW_LOGS_DIR/nginx_vulnerable.logs
docker exec $CONTAINER_NAME kubesec scan vuln-app.yaml > $NEW_LOGS_DIR/vuln-app_vulnerable.logs

docker rm -f $CONTAINER_NAME

echo "Analysis finished!"