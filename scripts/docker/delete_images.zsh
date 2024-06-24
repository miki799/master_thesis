#!/bin/zsh

source scripts/variables.zsh

echo "Deleting images $NGINX $NGINX_UNPRIVILEGED $ALPINE_DEV $VULN_APP $KUBESEC..."

docker rmi $NGINX $NGINX_UNPRIVILEGED $ALPINE_DEV $VULN_APP $KUBESEC