#!/bin/bash

set -e

echo "========================================"
echo "KOps Cluster Management"
echo "========================================"


CLUSTER_NAME=$1
STATE_BUCKET=$2
REGION=$3
ZONES=$4
AMI_ID=$5
MASTER_INSTANCE=$6
WORKER_INSTANCE=$7
MASTER_COUNT=$8
WORKER_COUNT=$9
MASTER_VOLUME=${10}
WORKER_VOLUME=${11}


export KOPS_STATE_STORE="s3://${STATE_BUCKET}"


echo "Cluster       : ${CLUSTER_NAME}"
echo "State Store   : ${KOPS_STATE_STORE}"
echo "Region        : ${REGION}"


echo "Checking if KOps cluster already exists..."


if kops get cluster --name=${CLUSTER_NAME} >/dev/null 2>&1
then

    echo "========================================"
    echo "Cluster already exists"
    echo "========================================"

    echo "Validating cluster..."

    kops validate cluster \
    --name=${CLUSTER_NAME}


else

    echo "========================================"
    echo "Cluster does not exist"
    echo "Creating new KOps cluster"
    echo "========================================"


    kops create cluster \
    --name=${CLUSTER_NAME} \
    --state=${KOPS_STATE_STORE} \
    --cloud=aws \
    --region=${REGION} \
    --zones=${ZONES} \
    --control-plane-ami=${AMI_ID} \
    --control-plane-size=${MASTER_INSTANCE} \
    --control-plane-count=${MASTER_COUNT} \
    --control-plane-volume-size=${MASTER_VOLUME} \
    --node-ami=${AMI_ID} \
    --node-size=${WORKER_INSTANCE} \
    --node-count=${WORKER_COUNT} \
    --node-volume-size=${WORKER_VOLUME}


    echo "Applying cluster configuration..."

    kops update cluster \
    --name=${CLUSTER_NAME} \
    --yes


    echo "========================================"
    echo "Waiting for cluster creation..."
    echo "========================================"


    sleep 250


    echo "Validating cluster..."

    kops validate cluster \
    --name=${CLUSTER_NAME}

fi


echo "========================================"
echo "KOps operation completed"
echo "========================================"