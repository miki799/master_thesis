#!/bin/zsh

source scripts/variables.zsh

echo "Deleting images $NGINX_DEV $ALPINE_DEV $VULN_APP..."

docker rmi $NGINX_DEV $ALPINE_DEV $VULN_APP