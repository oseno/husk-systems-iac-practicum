output "databricks_workspace_url" {
  description = "THe workspace URL for the Databricks environment."
  value       = azurerm_databricks_workspace.main.workspace_url
}
