#!/bin/bash

set -e

echo "========================================"
echo "KOps S3 State Store Validation"
echo "========================================"

BUCKET_NAME=$1
REGION=$2


if [ -z "$BUCKET_NAME" ] || [ -z "$REGION" ]; then
    echo "Usage: createS3.sh <bucket-name> <region>"
    exit 1
fi


echo "Bucket Name : $BUCKET_NAME"
echo "Region      : $REGION"


echo "Checking if S3 bucket exists..."


if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null
then

    echo "S3 bucket already exists"

else

    echo "S3 bucket does not exist"
    echo "Creating bucket..."
    
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$REGION"

    echo "S3 bucket created successfully"

fi

echo "Enabling S3 Versioning"

aws s3api put-bucket-versioning \
--bucket "$BUCKET_NAME" \
--versioning-configuration Status=Enabled


echo "========================================"
echo "KOps State Store Ready"
echo "========================================"

echo "Bucket : $BUCKET_NAME"
echo "Region : $REGION"