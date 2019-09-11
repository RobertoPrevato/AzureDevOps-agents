#!/bin/bash
################################################################################
##  File:  kubernetes-tools.sh
##  Team:  CI-Platform
##  Desc:  Installs kubectl, helm
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/document.sh
source $HELPER_SCRIPTS/apt.sh

## Install kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
mkdir kubectl && cd kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

mv ./kubectl /usr/local/bin/kubectl

cd ../

## Install helm
mkdir helm && cd helm

wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz

tar -zxvf helm-v2.14.3-linux-amd64.tar.gz

mv linux-amd64/helm /usr/local/bin/helm

cd ../

# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected, and basic scenarios work"
if ! command -v kubectl; then
    echo "kubectl was not installed"
    exit 1
fi

if ! command -v helm; then
    echo "helm was not installed"
    exit 1
fi

echo "Initializing helm"
helm init --client-only

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "kubectl ($(kubectl version --short |& head -n 1))"
DocumentInstalledItem "helm ($(helm version --short |& head -n 1))"
