#!/bin/zsh

source scripts/variables.zsh

USERNAMES=("developer") # add username
GROUPS=("devs") # add group name

create_user() {
  local username=$1
  local group=$2

  USER_DIR=$USERS_DIR/$username
  FILENAME_WITH_PATH=$USER_DIR/$username

  echo "Switching to admin user..."
  kubectl config use-context kind-$CLUSTER_NAME

  mkdir -p $USER_DIR

  echo "Creating user private key..."
  openssl genrsa -out $FILENAME_WITH_PATH.key 2048

  echo "Creating certificate signing request with generated user private key..."
  openssl req -new -nodes -key $FILENAME_WITH_PATH.key -out $FILENAME_WITH_PATH.csr -subj "/CN=$username/O=$group"

  echo "Creating k8s CertificateSigningRequest..."
  REQUEST=$(cat $FILENAME_WITH_PATH.csr | base64 | tr -d "\n")
  EXPIRATION=86400 # one day

  cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $username
spec:
  request: $REQUEST
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: $EXPIRATION
  usages:
  - client auth
EOF

  echo "Generated CSR for $username:"
  kubectl get csr

  echo "Approving CSR by K8s cluster CertificateAuthority (CA) for $username..."
  kubectl certificate approve $username

  echo "Retrieved certificate for $username:"
  kubectl get csr/$username -o yaml

  echo "Exporting certificate to the crt file..."
  kubectl get csr $username -o jsonpath='{.status.certificate}' | base64 -d > $FILENAME_WITH_PATH.crt

  echo "Adding user $username to the kubeconfig:"
  kubectl config set-credentials $username --client-key=$FILENAME_WITH_PATH.key --client-certificate=$FILENAME_WITH_PATH.crt --embed-certs=true
  kubectl config set-context $username --cluster=kind-$CLUSTER_NAME --user=$username
  kubectl config set-context $username --namespace $DEV_NAMESPACE

  echo -e "\n####################################################################################################################################### \n"
}

delete_user() {
  local username=$1

  echo "Switching to admin user..."
  kubectl config use-context kind-$CLUSTER_NAME

  echo "Cleaning up user $username..."

  echo "Deleting CertificateSigningRequest for user $username..."
  kubectl delete csr $username

  echo "Deleting context for user $username..."
  kubectl config delete-context $username

  echo "Deleting user $username..."
  kubectl config delete-user $username

  # Remove user directory if it exists
  USER_DIR=$USERS_DIR/$username
  if [ -d "$USER_DIR" ]; then
      echo "Removing user directory $USER_DIR..."
      rm -rf $USER_DIR
  fi

  echo "User $username deleted successfully."
  echo -e "\n####################################################################################################################################### \n"
}

# Function to display help message
display_help() {
  echo "Usage: $0 [-c | --create] [-d | --delete] [-h | --help]"
  echo "Options:"
  echo "  -c, --create   Create users"
  echo "  -d, --delete   Delete users"
  echo "  -h, --help     Display this help message"
}

# Check if any option is provided
if [ $# -eq 0 ]; then
  echo "Error: No option specified."
  display_help
  exit 1
fi

# Check the provided option
if [ "$1" = "-c" ] || [ "$1" = "--create" ]; then
  for ((i=1; i<=${#USERNAMES[@]}; i++)); do
    echo "Creating user ${USERNAMES[i]} with group ${GROUPS[i]}..."
    create_user ${USERNAMES[i]} ${GROUPS[i]}
  done
  exit 0
elif [ "$1" = "-d" ] || [ "$1" = "--delete" ]; then
  for ((i=1; i<=${#USERNAMES[@]}; i++)); do
    echo "Deleting user ${USERNAMES[i]}..."
    delete_user ${USERNAMES[i]}
  done
  exit 0
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  display_help
  exit 0
else
  echo "Error: Invalid option: $1"
  display_help
  exit 1
fi
