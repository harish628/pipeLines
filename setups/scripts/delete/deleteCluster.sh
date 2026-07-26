#!/bin/bash

set -e

CLUSTER_NAME=$1
KOPS_STATE_BUCKET=$2
REGION=$3

export KOPS_STATE_STORE="s3://${KOPS_STATE_BUCKET}"

echo "========================================"
echo "KOps Cluster Delete"
echo "========================================"

echo "Cluster Name : ${CLUSTER_NAME}"
echo "State Store  : ${KOPS_STATE_STORE}"
echo "Region       : ${REGION}"

echo "Checking if cluster exists..."

if kops get cluster "${CLUSTER_NAME}" >/dev/null 2>&1
then

    echo "Cluster exists"
    echo "Deleting cluster..."

    kops delete cluster \
    "${CLUSTER_NAME}" \
    --yes

    echo "========================================"
    echo "Cluster deletion initiated successfully"
    echo "========================================"

else

    echo "========================================"
    echo "Cluster does not exist"
    echo "Nothing to delete"
    echo "========================================"

fi