#!/bin/bash -x

# #abort on error
set -e

# Global variables.
region='us-west-2'
project='stormforge'
secret_name='secret/'$project''

# # Set default region
aws configure set default.region $region

# Generates secret and pipes into file
stormforge gen secret -o helm >  secret.yaml

#Isolates ID and Secret values. 
# client_id=$(cat secret.yaml | yq e '.data.STORMFORGE_AUTHORIZATION_CLIENT_ID' -)
# client_secret=$(cat secret.yaml | yq e '.data.STORMFORGE_AUTHORIZATION_CLIENT_SECRET' -)


#Creates secret 
aws secretsmanager create-secret --name $secret_name --secret-string file://secret.yaml


#Cleaning up files
rm secret.yaml



