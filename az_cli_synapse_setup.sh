#!/bin/bash

set -euo pipefail # Exit script if any command fails

# Configuration Variables
RESOURCE_GROUP_NAME="rg-prod-in-cmu"
LOCATION="southindia"
# Generate a unique name for the key vault
KEY_VAULT_NAME="synapse-kv-$(openssl rand -hex 4)"
SECRET_NAME="synapse-sql-admin-password"

# Check for password set as envrionment variable
if [ -z "$SYNAPSE_SQL_PASSWORD" ]; then
    echo "ERROR: The SQL password environment variable (SYNAPSE_SQL_PASSWORD) is not set"
    echo "Please set it before running the script."
    echo "Example: export SYNAPSE_SQL_PASSWORD='dontusemyweakpassword123'"
    exit 1
fi

echo "Creating Key Vault: $KEY_VAULT_NAME..."
# Create key vault
az keyvault create \
    --name $KEY_VAULT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --sku Standard \
    --enable-purge-protection true \
    --retention-days 90

echo "Storing secret: $SECRET_NAME..."
# Store password as secret in vault
az keyvault secret set \
    --vault-name $KEY_VAULT_NAME \
    --name $SECRET_NAME \
    --value "$SYNAPSE_SQL_PASSWORD"

# Grant the current user/service principal "Get" permission to secrets
# so that OpenTofu can read the secret during tofu apply
CURRENT_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)

if [ -z "$CURRENT_OBJECT_ID" ]; then
    echo "ERROR: Could not retrieve current user/service principal Object ID. Make sure you are logged in"
else
    echo "Granting 'GET' Secret Access to current user/service principal ($CURRENT_OBJECT_ID..."
    az role assignment create \
        --role "Key Vault Secrets User" \
        --assignee $CURRENT_OBJECT_ID \
        --scope /subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.KeyVault/vaults/$KEY_VAULT_NAME
    echo "RBAC Role "Key Vault Secrets User" assigned successfully."
fi

echo "Synapse Pre-setup Complete"
echo "Use the following values in the the tofu init command or you backend.tfvars file"
echo "Resource Group Name: $RESOURCE_GROUP_NAME"
echo "Key vault name: $KEY_VAULT_NAME"