#!/bin/sh

# wait for nginx server to start up
sleep 10

while true; do
    # Check if cacert file exists
    if [ -f "/etc/secret/tls.crt" ]; then
        curl --no-buffer --cacert /etc/secret/tls.crt https://nginx-svc.dev.svc.cluster.local:443
    else
        curl --no-buffer -k http://nginx-svc.dev.svc.cluster.local:80
    fi
    sleep 15
done