#!/bin/bash

set -euo pipefail # Exit script if any command fails

# Configuration Variables
RESOURCE_GROUP_NAME="rg-prod-in-cmu-iac"
# Generate a unique name for storage account
STORAGE_ACCOUNT_NAME="tfsa$(openssl rand -hex 4)"
CONTAINER_NAME="tfstate"
LOCATION="southindia"
# Generate a unique name for the key vault
KEY_VAULT_NAME="tf-kv-$(openssl rand -hex 4)"

# Will enable this once creation rights are granted
# echo "Creating Resource Group: $RESOURCE_GROUP_NAME in $LOCATION..."
# # Create resource group for state storage
# az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

echo "Creating Storage account: $STORAGE_ACCOUNT_NAME..."
# Create storage account 
# using LRS for cost and setting encryption services
az storage account create \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --sku Standard_LRS \
    --encryption-services blob 

echo "Creating Storage container: $CONTAINER_NAME..."
# Create storage containcer
# retrieve storage account key 
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $ACCOUNT_KEY

echo "OpenTofu State Backend Setup Complete"
echo "Resource Group Name: $RESOURCE_GROUP_NAME"
echo "Storage account name: $STORAGE_ACCOUNT_NAME"
echo "Container name: $CONTAINER_NAME"