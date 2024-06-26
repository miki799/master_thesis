#!/bin/zsh

source scripts/variables.zsh

echo "Building Application Docker images..."

cd $DOCKER_DIR/alpine-dev && \
docker build --build-arg IMAGE_NAME_WITH_TAG=$ALPINE_DEV_BASE_IMAGE -t $ALPINE_DEV .

cd $DOCKER_DIR/nginx && \
docker build --build-arg IMAGE_NAME_WITH_TAG=$NGINX_BASE_IMAGE -t $NGINX .

cd $DOCKER_DIR/nginx_unprivileged && \
docker build --build-arg IMAGE_NAME_WITH_TAG=$NGINX_UNPRIVILEGED_BASE_IMAGE -t $NGINX_UNPRIVILEGED .

cd $DOCKER_DIR/vuln-app && \
docker build --build-arg IMAGE_NAME_WITH_TAG=$VULN_APP_BASE_IMAGE -t $VULN_APP .

echo "Finished building Application Docker images!"

echo "Loading Docker images to the Kind cluster..."

if kubectl get node $CP_NODE_NAME &> /dev/null; then
    kind load docker-image $VULN_APP $ALPINE_DEV $NGINX_UNPRIVILEGED $NGINX --name $CLUSTER_NAME
    echo "Finished!"
else
    echo "$CP_NODE_NAME node does not exist!"
fi

echo "Building tools Docker images..."

cd $DOCKER_DIR/kubesec && \
docker build --build-arg IMAGE_NAME_WITH_TAG=$KUBESEC_BASE_IMAGE --build-arg KUBESEC_VERSION=$KUBESEC_VERSION -t $KUBESEC .

echo "Finished tools Docker images!"