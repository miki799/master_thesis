#!/bin/sh

# wait for nginx server to start up
sleep 10

while true; do
    curl --no-buffer --connect-timeout 5 --cacert /etc/secret/ca.crt \
    https://nginx-svc.dev.svc.cluster.local:4430
    sleep 15
done