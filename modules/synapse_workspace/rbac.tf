resource "azurerm_role_assignment" "synapse_storage_blob_data_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contibutor"
  principal_id         = azurerm_synapse_workspace.main.identity.principal_id
}
