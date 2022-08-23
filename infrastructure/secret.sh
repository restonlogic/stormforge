#!/bin/bash -x

# #abort on error
set -e

# Global variables.
region='us-east-2'
project='stormforge'
secret_name='/stormforge/optimize-secrets'

# # Set default region
aws configure set default.region $region

# Generates secret and pipes into file
stormforge gen secret -o helm >  secret.yaml

#Creates secret 
aws secretsmanager create-secret --name $secret_name --secret-string file://secret.yaml


#Cleaning up files
rm secret.yaml



