#!/bin/bash
set -e

action=$1
project=$2

if [ -z $action ] || [ -z $project ]; then
    echo "$0 <action> <project>"
    exit 1
fi

REGION_NAME=$(aws ssm get-parameter --name /tf/${project}/regionName | jq -r '.Parameter.Value')
BUCKET_NAME=$(aws ssm get-parameter --name "/tf/${project}/tfBucketName" --region ${REGION_NAME} | jq -r '.Parameter.Value')
export AWS_DEFAULT_REGION=$REGION_NAME

if [ -z $BUCKET_NAME ]; then
    echo "Terraform bucketname not set or found. "
    exit 1
fi

rm -rf .terraform
rm -rf .terraform.lock.hcl
terraform init \
    -backend-config="bucket=${BUCKET_NAME}" \
    -backend-config="region=${REGION_NAME}" \
    -backend-config="key=${project}-network-services-terraform.state"

terraform validate
case $action in
apply)
    echo "Running Terraform Apply Full"
    terraform apply -auto-approve -var-file=../${project}.tfvars -compact-warnings
    ;;
destroy)
    echo "Running Terraform Destroy"
    terraform destroy -auto-approve -var-file=../${project}.tfvars -compact-warnings
    ;;
plan)
    echo "Running Terraform Plan"
    terraform plan -var-file=../${project}.tfvars -compact-warnings
    ;;
esac
