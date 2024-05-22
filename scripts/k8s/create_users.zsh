#!/bin/zsh

# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#normal-user

source scripts/variables.zsh

# Switching to admin user

echo "Switching to admin user..."
kubectl config use-context kind-$CLUSTER_NAME

# Deleting old csr and user from kubeconfig before creating a new user

echo "Cleaning up after old user..."
kubectl delete csr $CLUSTER_USERNAME
kubectl config delete-context $CLUSTER_USERNAME
kubectl config delete-user $CLUSTER_USERNAME

USER_DIR=$USERS_DIR/$CLUSTER_USERNAME
FILENAME_WITH_PATH=$USER_DIR/$CLUSTER_USERNAME

echo "Creating user: $CLUSTER_USERNAME...."

mkdir -p $USER_DIR

# Create user private key

echo "Creating user private key..."
openssl genrsa -out $FILENAME_WITH_PATH.key 2048

# Create certificate signiing request with generated user private key

echo "Creating certificate signing request with generated user private key..."
openssl req -new -nodes -key $FILENAME_WITH_PATH.key -out $FILENAME_WITH_PATH.csr -subj "/CN=$CLUSTER_USERNAME/O=$GROUP"

# Create a CertificateSigningRequest

echo "Creating k8s CertificateSigningRequest..."

REQUEST=$(cat $FILENAME_WITH_PATH.csr | base64 | tr -d "\n")
EXPIRATION=86400 # one day

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $CLUSTER_USERNAME
spec:
  request: $REQUEST
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: $EXPIRATION
  usages:
  - client auth
EOF

# Check if CSR is created

echo "Generated CSR:"
kubectl get csr

# Approve the CSR

echo "Approving CSR by K8s cluster CertificateAuthority (CA)..."
kubectl certificate approve $CLUSTER_USERNAME

# Retrieve the certificate

echo "Retrieved certificate:"
kubectl get csr/$CLUSTER_USERNAME -o yaml

# Export the certificate to crt file

echo "Exporting certiifacte to the crt file..."
kubectl get csr $CLUSTER_USERNAME -o jsonpath='{.status.certificate}'| base64 -d > $FILENAME_WITH_PATH.crt

# Add to kubeconfig

echo "Adding user to the kubeconfig:"
kubectl config set-credentials $CLUSTER_USERNAME --client-key=$FILENAME_WITH_PATH.key --client-certificate=$FILENAME_WITH_PATH.crt --embed-certs=true
kubectl config set-context $CLUSTER_USERNAME --cluster=kind-$CLUSTER_NAME --user=$CLUSTER_USERNAME
kubectl config use-context $CLUSTER_USERNAME
