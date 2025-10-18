resource "azurerm_storage_account" "main" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true

  tags = var.tags
}

resource "azurerm_storage_container" "filesystem" {
  name                  = var.filesystem_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
