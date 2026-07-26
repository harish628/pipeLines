#!/bin/bash

set -e

echo "========================================"
echo "Checking kubectl Installation"
echo "========================================"

if command -v kubectl >/dev/null 2>&1; then
    echo "kubectl is already installed."
    kubectl version --client
    exit 0
fi

echo "kubectl not found. Installing..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

echo
echo "Installation Successful"

kubectl version --client