#!/bin/bash

set -e

CLUSTER_NAME=$1
KOPS_STATE_BUCKET=$2
REGION=$3

export KOPS_STATE_STORE="s3://${KOPS_STATE_BUCKET}"
export AWS_DEFAULT_REGION="${REGION}"

echo "========================================"
echo "KOps Cluster Status"
echo "========================================"

echo "State Store : ${KOPS_STATE_STORE}"
echo "Region      : ${REGION}"


echo ""
echo "Checking AWS Identity"
aws sts get-caller-identity


echo ""
echo "========================================"
echo "Available KOps Clusters"
echo "========================================"


CLUSTERS=$(kops get clusters --output name)


if [ -z "$CLUSTERS" ]
then
    echo "No KOps clusters found"
    exit 0
else
    echo "$CLUSTERS"
fi


echo ""
echo "========================================"
echo "Checking Selected Cluster"
echo "========================================"


if kops get cluster "${CLUSTER_NAME}" >/dev/null 2>&1
then

    echo "Cluster Status : EXISTS"

    echo ""
    echo "Cluster Details"
    kops get cluster "${CLUSTER_NAME}"


    echo ""
    echo "Instance Groups"
    kops get ig --name "${CLUSTER_NAME}"


    echo ""
    echo "Kubernetes Nodes"

    if kubectl get nodes >/dev/null 2>&1
    then
        kubectl get nodes -o wide
    else
        echo "Kubernetes API not reachable"
    fi


    echo ""
    echo "Cluster Validation"

    kops validate cluster \
    --name "${CLUSTER_NAME}"

else

    echo "Cluster Status : NOT FOUND"

fi


echo ""
echo "========================================"
echo "Status Check Completed"
echo "========================================"