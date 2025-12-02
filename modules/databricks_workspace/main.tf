data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name # assuming the key vault are in the same RG as the other resources
}

resource "azurerm_key_vault_access_policy" "databricks_access" {
  count = length(azurerm_databricks_workspace.main.storage_account_identity) > 0 ? 1 : 0

  key_vault_id = data.azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_key_vault.key_vault.tenant_id
  object_id = azurerm_databricks_workspace.main.storage_account_identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_databricks_workspace" "main" {
  name                        = var.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku_name
  managed_resource_group_name = "${var.resource_group_name}-db-managed"

  tags = var.tags
}

