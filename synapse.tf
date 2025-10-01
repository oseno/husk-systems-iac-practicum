# synapse.tf
# Initial Synapse workspace definition

# Initial synapse definition has
# Storage account for Synapse data lake
# Synapse workspace resource 
# Data Lake Gen2 filesystem 
# Basic authentication (SQL admin) 
# 
# Mark will implement variables.tf and 
# Networking configuration
# Firewall rules
# Compute pools (SQL pools, Spark pools)
# Advanced security settings


locals {
  synapse_storage_name = "sadevngcmusynapse"
  synapse_workspace_name = "synw-dev-ng-cmu-main"
}

# Storage account for Synapse Data Lake
resource "azurerm_storage_account" "synapse_datalake" {
  name                     = local.synapse_storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true  # Hierarchical namespace required for Synapse

  tags = merge(
    local.common_tags,
    {
      Purpose = "Synapse Data Lake Storage"
      Sprint  = "Sprint-1"
    }
  )
}

# Data Lake Gen2 Filesystem for Synapse
resource "azurerm_storage_data_lake_gen2_filesystem" "synapse" {
  name               = "synapse-workspace"
  storage_account_id = azurerm_storage_account.synapse_datalake.id
}

# Synapse Workspace - Basic configuration
resource "azurerm_synapse_workspace" "main" {
  name                = local.synapse_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.synapse.id
  
  sql_administrator_login          = var.synapse_sql_admin_login
  sql_administrator_login_password = var.synapse_sql_admin_password

  # Basic identity configuration
  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    local.common_tags,
    {
      Purpose = "Data Analytics Platform"
      Sprint  = "Sprint-1"
    }
  )
}

# Grant Synapse workspace access to storage
resource "azurerm_role_assignment" "synapse_storage_blob_contributor" {
  scope                = azurerm_storage_account.synapse_datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.main.identity[0].principal_id
}

# Outputs
output "synapse_workspace_id" {
  value       = azurerm_synapse_workspace.main.id
  description = "ID of the Synapse workspace"
}

output "synapse_workspace_name" {
  value       = azurerm_synapse_workspace.main.name
  description = "Name of the Synapse workspace"
}

output "synapse_storage_account_name" {
  value       = azurerm_storage_account.synapse_datalake.name
  description = "Name of the Synapse storage account"
}