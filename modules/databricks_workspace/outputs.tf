output "databricks_workspace_url" {
  description = "THe workspace URL for the Databricks environment."
  value       = azurerm_databricks_workspace.main.workspace_url
}

output "key_vault_secret_scope_name" {
  description = "The name of the Key Vault-backed secret scope."
  value       = databricks_secret_scope.keyvault_backed.name
}

output "databricks_group_name" {
  description = "The display name of the Data Engineers Databricks group."
  value       = databricks_group.data_engineers.display_name
}

output "databricks_cluster_policy_id" {
  description = "The ID of the optimizd autoscaling cluster policy."
  value       = databricks_cluster_policy.optimized_autoscaling.id
}
