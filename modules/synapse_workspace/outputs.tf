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
  description = "The SQL administrator password for Synapse."
  value       = random_password.sql_admin_password.result
  sensitive   = true
}

output "synapse_msi_principal_id" {
  description = "The Principal ID of the Synapse Workspace's system assigned managed identity."
  value       = azurerm_synapse_workspace.main.identity.principal_id

}
