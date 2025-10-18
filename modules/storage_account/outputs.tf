output "id" {
  value       = azurerm_storage_account.main.id
  description = "The ID of the storage account."
}

output "name" {
  value       = azurerm_storage_account.main.name
  description = "The name of the storage account."
}

output "primary_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account."
  sensitive   = true
}

output "filesystem_id" {
  value       = azurerm_storage_container.filesystem.id
  description = "The ID of the data lake gen2 filesystem (container)."
}

output "filesystem_url" {
  value       = azurerm_storage_container.filesystem.resource_manager_id
  description = "The resource manager ID of the data lake gen2 filesystem."
}

output "filesystem_synapse_url" {
  value       = "https://${azurerm_storage_account.main.name}.dfs.core.windows.net/${azurerm_storage_container.filesystem.name}"
  description = "The URL of the data lake gen2 filesystem (container) in Synapse preferred format."
}
