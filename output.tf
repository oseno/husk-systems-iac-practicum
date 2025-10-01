output "test_storage_account_id" {
  value       = azurerm_storage_account.test.id
  description = "Resource ID of the test storage account"
}

output "test_storage_account_name" {
  value       = azurerm_storage_account.test.name
  description = "Name of the test storage account"
}

output "test_storage_primary_connection_string" {
  value       = azurerm_storage_account.test.primary_connection_string
  description = "Primary connection string for the storage account"
  sensitive   = true
}

output "resource_group_used" {
  value       = var.resource_group_name
  description = "Resource group where resources were deployed"
}