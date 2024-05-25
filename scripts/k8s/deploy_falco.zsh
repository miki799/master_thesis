#!/bin/zsh

source scripts/variables.zsh

# Deploy Falco (currently only for syscalls)

echo "Deploying falco!"

if helm repo list | grep -q 'falcosecurity'; then
  echo "falcosecurity repository already added"
else
  helm repo add falcosecurity https://falcosecurity.github.io/charts
fi

helm repo update

helm install falco falcosecurity/falco \
     --set tty=true \
     --namespace $FALCO_NAMESPACE \
     --set driver.kind=modern_ebpf \
     -f $K8S_SEC_DIR/falco/rules/custom-rules.yaml
    #  --set falcosidekick.enabled=true \
    #  --set falcosidekick.webui.enabled=true \
    #  --set auditLog.enabled=true

    #  Currently not working directly on Mac with Linuxkit, but these directions work on Linux guest OS running kind.
    #  --values=https://raw.githubusercontent.com/falcosecurity/charts/master/charts/falco/values-syscall-k8saudit.yaml

echo "Falco deployed!"