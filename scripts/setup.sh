#!/bin/sh

#1 Create namespaces

kubectl apply -f namespaces.yaml

#2 Create nginx secret (self-signed certificate)

# -x509 - This option specifies that the command should generate a self-signed certificate rather than a CSR.
# -nodes - openssl won't encrypt the key (no password)
# -days - certificate validity time
# -newkey rsa:2048 - generates RSA 2048bits private key
# -keyout - where the generated key should be saved
# -out - where the generated private key should be saved
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./nginx/nginx.key -out ./nginx/nginx.crt

kubectl create secret generic nginx-secret -n mt-development  --from-file=./nginx/nginx.key --from-file=./nginx/nginx.crt

#2 Deploy nginx-svc service (NodePort), nginx-cm (ConfigMap) and nginx (Pod)

kubectl apply -f nginx/nginx.yaml