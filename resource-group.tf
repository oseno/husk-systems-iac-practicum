# resource-group.tf
# Reference to existing resource group (cannot create new ones with permissions)

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

output "resource_group_id" {
  value       = data.azurerm_resource_group.main.id
  description = "ID of the existing resource group we deploy into"
}

output "resource_group_location" {
  value       = data.azurerm_resource_group.main.location
  description = "Location of the resource group"
}