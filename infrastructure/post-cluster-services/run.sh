#!/bin/bash -x
action=$1
project=$2
git_user=$3
git_token=$4
git_repo=$5

if [ -z $action ] || [ -z $project ]; then
    echo "$0 <action> <project>"
    exit 1
fi

REGION_NAME=$(aws ssm get-parameter --name /tf/${project}/regionName | jq -r '.Parameter.Value')
BUCKET_NAME=$(aws ssm get-parameter --name "/tf/${project}/tfBucketName" --region ${REGION_NAME} | jq -r '.Parameter.Value')

export AWS_DEFAULT_REGION=$REGION_NAME
echo "Deploying $project environment"

rm -rf .terraform
rm -rf .terraform*

terraform init \
    -backend-config="bucket=${BUCKET_NAME}" \
    -backend-config="region=${REGION_NAME}" \
    -backend-config="key=${project}-post-cluster-services-terraform.state"

terraform validate

case $action in
apply)
    echo "Running Terraform Apply Full"
    terraform apply -auto-approve -var=git_user=${git_user} -var=git_token=${git_token} -var=git_repo=${git_repo} -var-file=../${project}.tfvars -compact-warnings
    ;;
destroy)
    echo "Running Terraform Destroy"
    terraform destroy -auto-approve -var=git_user=${git_user} -var=git_token=${git_token} -var=git_repo=${git_repo} -var-file=../${project}.tfvars -compact-warnings
    ;;
plan)
    echo "Running Terraform Plan"
    terraform plan -var=git_user=${git_user} -var=git_token=${git_token} -var=git_repo=${git_repo} -var-file=../${project}.tfvars -compact-warnings
    ;;
esac
