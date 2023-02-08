#!/bin/bash

#abort on error
set -e

# Option defaults
OPT="value"

# getopts string
# This string needs to be updated with the single character options (e.g. -f)
opts="u:t:r:a"

# Gets the command name without path
cmd() { echo $(basename $0); }

# Help command output
usage() {
    echo "\
$(cmd) [OPTION...]
-u, --git_user; provide a Github username
-t, --git_token; provide a Github token
-r, --git_repo; GitHub repo name
-a, --aws_region; AWS Region to use
" | column -t -s ";"
}

# Error message
error() {
    echo "$(cmd): invalid option -- '$1'"
    exit 1
}

# There's two passes here. The first pass handles the long options and
# any short option that is already in canonical form. The second pass
# uses `getopt` to canonicalize any remaining short options and handle
# them

for pass in 1 2; do
    while [ -n "$1" ]; do
        case $1 in
        --)
            shift
            break
            ;;
        -*) case $1 in
            -u | --git_user)
                git_user=$2
                shift
                ;;
            -r | --git_repo)
                git_repo=$2
                shift
                ;;
            -t | --git_token)
                git_token=$2
                shift
                ;;
            -a | --aws_region)
                AWS_REGION=$2
                shift
                ;;
            -v | --verbose) VERBOSE=$(($VERBOSE + 1)) ;;
            --*) error $1 ;;
            -*) if [ $pass -eq 1 ]; then
                ARGS="$ARGS $1"
            else error $1; fi ;;
            esac ;;
        *) if [ $pass -eq 1 ]; then
            ARGS="$ARGS $1"
        else error $1; fi ;;
        esac
        shift
    done
    if [ $pass -eq 1 ]; then
        ARGS=$(getopt $opts $ARGS)
        if [ $? != 0 ]; then
            usage
            exit 2
        fi
        set -- $ARGS
    fi
done

# Handle positional arguments
if [ -n "$*" ]; then
    echo "$(cmd): Extra arguments -- $*"
    echo "Try '$(cmd) -h' for more information."
    exit 1
fi

if [ -z $AWS_REGION ] || [ -z $git_token ] || [ -z $git_user ] || [ -z $git_repo ]; then
    echo "missing parameters, please see options below"
    usage
    exit 1
fi

# Global variables.
project='stormforge'

# Get account id info for this AWS
accountid=$(aws sts get-caller-identity | jq -r '.Account')

# Set default region
aws configure set default.region $AWS_REGION

# Bucket to store terraform state files.  Append the accountID to make it unique
BUCKET_NAME="terraform-state-${project}-${accountid}"

# Create terraform state bucket
echo "Creating Terraform Backend Bucket: ${BUCKET_NAME}"

BUCKET_EXISTS=$(aws s3api head-bucket --bucket ${BUCKET_NAME} 2>&1 || true)
if [ -z "$BUCKET_EXISTS" ]; then
    printf "Terraform state bucket exists.skipping${NC}\n"
else
    echo "Bucket does not exist"
    aws s3 mb s3://$BUCKET_NAME --region $AWS_REGION
fi

aws ssm put-parameter --name /tf/${project}/tfBucketName --overwrite --type String --value $BUCKET_NAME >/dev/null
aws ssm put-parameter --name /tf/${project}/regionName --overwrite --type String --value $AWS_REGION >/dev/null

#for service in network cluster app_services lambda_deployment post-cluster mgmt-services monitoring security; do
for service in network-services cluster-services post-cluster-services optimize-pro; do
    echo "Creating ${service} service for project ${project} ..."
    cd ${PWD}/${service}
    ./run.sh apply $project $git_user $git_token $git_repo
    cd ..
done

# # Print endpoints
# bash bin/get-endpoints.sh
