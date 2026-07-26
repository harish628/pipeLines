#!/bin/bash

set -e

echo "========================================"
echo "Checking KOps Installation"
echo "========================================"

if command -v kops >/dev/null 2>&1; then
    echo "KOps is already installed."
    kops version
    exit 0
fi

echo "KOps not found. Installing..."

LATEST_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest \
    | grep tag_name \
    | cut -d '"' -f4)

echo "Latest Version : ${LATEST_VERSION}"

curl -Lo kops \
https://github.com/kubernetes/kops/releases/download/${LATEST_VERSION}/kops-linux-amd64

chmod +x kops

sudo mv kops /usr/local/bin/

echo
echo "Installation Successful"
kops version