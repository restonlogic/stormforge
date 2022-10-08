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
            # -k | --aws-access-key-id)
            #     AWS_ACCESS_KEY_ID=$2
            #     shift
            #     ;;
            # -s | --aws-secret-access-key)
            #     AWS_SECRET_ACCESS=$2
            #     shift
            #     ;;
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

# Global variables.
project='stormforge'

# Get account id info for this AWS
accountid=$(aws sts get-caller-identity | jq -r '.Account')

# Set default region
aws configure set default.region $AWS_REGION

# Bucket to store terraform state files.  Append the accountID to make it unique
BUCKET_NAME="terraform-state-${project}-${accountid}"

#for service in network cluster app_services lambda_deployment post-cluster mgmt-services monitoring security; do
for service in post-cluster-services cluster-services network-services; do
    echo "Destroying ${service} service for project ${project} ..."
    cd ${PWD}/${service}
    ./run.sh destroy $project $git_user $git_token $git_repo
    cd ..
done

# Delete terraform state bucket
echo "Deleting Terraform Backend Bucket: ${BUCKET_NAME}"
export AWS_DEFAULT_REGION=$AWS_REGION
aws s3 rb s3://${BUCKET_NAME} --force --region ${AWS_REGION}

#Delete parameter
aws ssm delete-parameter --name /tf/${project}/tfBucketName
aws ssm delete-parameter --name /tf/${project}/regionName




# # Print endpoints
# bash bin/get-endpoints.sh
