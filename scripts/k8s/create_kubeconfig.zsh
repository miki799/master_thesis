#!/bin/zsh

CA_CERT=$(cat ./artifacts/attacker_stuff/ca.crt)
USER_CERT=$(cat ./artifacts/attacker_stuff/impostor.crt)
USER_KEY=$(cat ./artifacts/attacker_stuff/impostor.key)
KUBECONFIG_OUTPUT=./artifacts/attacker_stuff/kubeconfig.yaml

K8S_IP=127.0.0.1
K8S_PORT=6443
CLUSTER=target-cluster
CONTEXT=impostor-context
K8S_USER=impostor

ENCODED_CA_CERT=$(echo $CA_CERT | base64)
ENCODED_USER_CERT=$(echo $USER_CERT | base64)
ENCODED_USER_KEY=$(echo $USER_KEY | base64)

cat <<EOF > "$KUBECONFIG_OUTPUT"
apiVersion: v1
clusters:
  - name: $TARGET_CLUSTER
    cluster:
      certificate-authority-data: $ENCODED_CA_CERT
      server: https://$K8S_IP:$K8S_PORT
contexts:
  - name: $CONTEXT
    context:
      cluster: $TARGET_CLUSTER
      user: $K8S_USER
current-context: $CONTEXT
kind: Config
preferences: {}
users:
  - name: $K8S_USER
    user:
      client-certificate-data: $ENCODED_USER_CERT
      client-key-data: $ENCODED_USER_KEY
EOF

echo "Generated kubeconfig: $KUBECONFIG_OUTPUT"
