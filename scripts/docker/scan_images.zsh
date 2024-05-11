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

echo "Scanning image $NGINX image used by nginx-dev pod..."
trivy image $NGINX --scanners vuln > $NEW_LOGS_DIR/$NGINX.logs
echo "Scan finished!"