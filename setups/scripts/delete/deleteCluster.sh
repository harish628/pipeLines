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

echo ""
echo "========================================"
echo "Checking S3 State Store"
echo "========================================"

if aws s3api head-bucket --bucket "${KOPS_STATE_BUCKET}" 2>/dev/null
then

    echo "S3 bucket exists"

    echo "Deleting all object versions..."

    echo "Listing object versions..."

    OUTPUT=$(aws s3api list-object-versions \
        --bucket "${KOPS_STATE_BUCKET}" \
        --output json 2>&1)

    echo "AWS CLI Output:"
    echo "$OUTPUT"

    echo "$OUTPUT" | jq .

    echo "$OUTPUT" | jq -c '.Versions[]?, .DeleteMarkers[]?' |
    while read obj
    do
        echo "Deleting: $obj"

        aws s3api delete-object \
            --bucket "${KOPS_STATE_BUCKET}" \
            --key "$(echo "$obj" | jq -r '.Key')" \
            --version-id "$(echo "$obj" | jq -r '.VersionId')"
    done

    echo "Deleting bucket..."

    aws s3api delete-bucket \
        --bucket "${KOPS_STATE_BUCKET}" \
        --region "${REGION}"

    echo "S3 bucket deleted successfully"

else

    echo "S3 bucket does not exist"
    echo "Skipping S3 deletion"

fi

echo ""
echo "========================================"
echo "Cleanup Completed"
echo "========================================"