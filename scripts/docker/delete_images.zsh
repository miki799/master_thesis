#!/bin/zsh

source scripts/variables.zsh

echo "Deleting images $NGINX_DEV $ALPINE_DEV $VULN_APP $ALPINE_SEC..."

docker rmi $NGINX_DEV $ALPINE_DEV $VULN_APP $ALPINE_SEC