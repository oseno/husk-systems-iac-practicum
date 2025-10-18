output "resource_group_name" {
  value       = data.azurerm_resource_group.main.name
  description = "The name of the resource group created"
}

output "synapse_workspace_name" {
  description = "The name of the Azure Synapse workspace."
  value       = module.synapse_workspace.synapse_workspace_name
}

output "synapse_workspace_url" {
  description = "The URL of the Synapse Studio web interface."
  value       = module.synapse_workspace.synapse_workspace_url
}

output "synapse_sql_endpoint" {
  description = "The URL of the Synapse SQL endpoint."
  value       = module.synapse_workspace.synapse_sql_endpoint
}

output "synapse_msi_principal_id" {
  description = "The Principal ID of the Synapse Workspace's system assigned managed identity."
  value       = module.synapse_workspace.synapse_msi_principal_id
}

output "synapse_sql_administrator_login" {
  description = "The SQL administrator login name for Synapse."
  value       = module.synapse_workspace.sql_administrator_login
}

output "synapse_sql_administrator_password" {
  description = "The SQL administrator password for Synapse."
  value       = module.synapse_workspace.sql_administrator_password
  sensitive   = true
}

output "date_lake_storage_account_name" {
  description = "The name of the data lake gen2 storage account."
  value       = module.storage_account.name
}

output "date_lake_filesystem_name" {
  description = "The name of the data lake gen2 filesystem (container)."
  value       = module.storage_account.name
}
