output "synapse_workspace_id" {
  description = "The ID of the Azure Synapse workspace."
  value       = azurerm_synapse_workspace.main.id
}

output "synapse_workspace_name" {
  description = "The name of the Azure Synapse workspace."
  value       = azurerm_synapse_workspace.main.name
}

output "synapse_workspace_url" {
  description = "The URL of the Synapse Studio web interface."
  value       = azurerm_synapse_workspace.main.connectivity_endpoints["web"]
}

output "synapse_sql_endpoint" {
  description = "The URL of the Synapse SQL endpoint."
  value       = azurerm_synapse_workspace.main.connectivity_endpoints["sql"]
}

output "synapse_dev_endpoint" {
  description = "The developer URL of the Synapse workspace."
  value       = azurerm_synapse_workspace.main.connectivity_endpoints["dev"]
}

output "sql_administrator_login" {
  description = "The SQL administrator login for Synapse."
  value       = azurerm_synapse_workspace.main.sql_administrator_login
}

output "sql_administrator_password" {
  description = "The SQL administrator password retrieved from Azure key vault."
  value       = data.azurerm_key_vault_secret.sql_admin_password.id
  sensitive   = true
}

output "synapse_msi_principal_id" {
  description = "The Principal ID of the Synapse Workspace's system assigned managed identity."
  value       = azurerm_synapse_workspace.main.identity.principal_id
}

output "sql_pool_id" {
  description = "The ID of the default Synapse SQL pool."
  value       = azurerm_synapse_sql_pool.main.id
}

output "spark_pool_id" {
  description = "The ID of default Synapse Spark pool."
  value       = azurerm_synapse_spark_pool.main.id
}
