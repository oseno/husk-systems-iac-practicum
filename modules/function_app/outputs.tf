output "function_app_plan_id" {
  description = "ID of the Function App Service Plan"
  value       = azurerm_service_plan.function.id
}

output "function_app_plan_name" {
  description = "Name of the Function App Service Plan"
  value       = azurerm_service_plan.function.name
}

output "function_app_id" {
  description = "ID of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.main[0].id : azurerm_windows_function_app.main[0].id
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = var.function_app_name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.main[0].default_hostname : azurerm_windows_function_app.main[0].default_hostname
}

output "function_app_identity_principal_id" {
  description = "Principal ID of the Function App managed identity"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.main[0].identity[0].principal_id : azurerm_windows_function_app.main[0].identity[0].principal_id
}

output "storage_account_name" {
  description = "Name of the storage account used by Function App"
  value       = azurerm_storage_account.function.name
}