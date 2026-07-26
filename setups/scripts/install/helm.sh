#!/bin/bash

set -e

echo "========================================"
echo "Checking Helm Installation"
echo "========================================"

if command -v helm >/dev/null 2>&1; then
    echo "Helm is already installed."
    helm version
    exit 0
fi


echo "Helm not found. Installing..."


curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash


echo
echo "Helm Installation Successful"

helm version