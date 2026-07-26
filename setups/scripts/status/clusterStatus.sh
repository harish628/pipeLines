#!/bin/bash

set -e

CLUSTER_NAME=$1
KOPS_STATE_BUCKET=$2
REGION=$3

export KOPS_STATE_STORE="s3://${KOPS_STATE_BUCKET}"

echo "========================================"
echo "KOps Cluster Status"
echo "========================================"

echo "State Store : ${KOPS_STATE_STORE}"
echo "Region      : ${REGION}"


echo ""
echo "========================================"
echo "Available KOps Clusters"
echo "========================================"


CLUSTERS=$(kops get clusters --output name 2>/dev/null || true)


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

echo "Cluster Name : ${CLUSTER_NAME}"


if kops get cluster "${CLUSTER_NAME}" >/dev/null 2>&1
then

    echo "Cluster Status : EXISTS"


    echo ""
    echo "========================================"
    echo "Cluster Details"
    echo "========================================"

    kops get cluster "${CLUSTER_NAME}"


    echo ""
    echo "========================================"
    echo "Instance Groups"
    echo "========================================"

    kops get ig \
    --name "${CLUSTER_NAME}"


    echo ""
    echo "========================================"
    echo "Kubernetes Nodes"
    echo "========================================"


    if kubectl get nodes >/dev/null 2>&1
    then

        kubectl get nodes -o wide

    else

        echo "Kubernetes API not reachable"

    fi


    echo ""
    echo "========================================"
    echo "Cluster Validation"
    echo "========================================"

    kops validate cluster \
    --name "${CLUSTER_NAME}"


else

    echo "Cluster Status : NOT FOUND"

fi


echo ""
echo "========================================"
echo "Status Check Completed"
echo "========================================"