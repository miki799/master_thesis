#!/bin/zsh

source scripts/variables.zsh

# Trivy

NEW_LOGS_DIR=$TRIVY_LOGS_DIR/$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p $NEW_LOGS_DIR

echo "Scanning $ALPINE_DEV_BASE_IMAGE image used as base image for building $ALPINE_DEV..."
trivy image $ALPINE_DEV_BASE_IMAGE --scanners vuln > $NEW_LOGS_DIR/$ALPINE_DEV_BASE_IMAGE.logs
echo "Scan finished!"

echo "Scanning $VULN_APP_BASE_IMAGE image used as base image for building $VULN_APP..."
trivy image $VULN_APP_BASE_IMAGE --scanners vuln > $NEW_LOGS_DIR/$VULN_APP_BASE_IMAGE.logs
echo "Scan finished!"

echo "Scanning image $NGINX_BASE_IMAGE image used by $NGINX pod..."
trivy image $NGINX_BASE_IMAGE --scanners vuln > $NEW_LOGS_DIR/$NGINX_BASE_IMAGE.logs
echo "Scan finished!"

echo "Scanning image $NGINX_UNPRIVILEGED_BASE_IMAGE image used by $NGINX_UNPRIVILEGED..."
trivy image $NGINX_UNPRIVILEGED_BASE_IMAGE --scanners vuln > $NEW_LOGS_DIR/nginxinc_slash_nginx-unprivileged:1.26.1-alpine.logs
echo "Scan finished!"