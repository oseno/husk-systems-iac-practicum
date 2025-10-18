data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}


module "storage_account" {
  source = "./modules/storage_account"

  name                = "${var.environment}${var.project_name}sa${random_string.suffix.result}" # unique storage account name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  filesystem_name     = "${var.project_name}-${var.environment}-fs"
  tags                = var.tags
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

module "synapse_workspace" {
  source = "./modules/synapse_workspace"

  name                                 = "${var.environment}-${var.project_name}-synapse"
  resource_group_name                  = data.azurerm_resource_group.main.name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = module.storage_account.filesystem_synapse_url
  storage_account_id                   = module.storage_account.id # for rbac
  sql_administrator_login              = var.sql_administrator_login
  managed_virtual_network_enabled      = var.synapse_managed_vnet_enabled
  sql_pool_sku                         = var.synapse_sql_pool_sku
  spark_pool_node_count                = var.synapse_spark_pool_node_count
  spark_pool_node_size_family          = var.synapse_spark_pool_node_size_family
  spark_pool_node_size                 = var.synapse_spark_pool_node_size
  spark_pool_version                   = var.synapse_spark_pool_version
  spark_pool_auto_pause_enabled        = var.synapse_spark_pool_auto_pause_enabled
  spark_pool_auto_scale_enabled        = var.synapse_spark_pool_auto_scale_enabled
  spark_pool_min_node_count            = var.synapse_spark_pool_min_node_count
  spark_pool_max_node_count            = var.synapse_spark_pool_max_node_count
  spark_pool_delay_in_minutes          = var.synapse_spark_pool_delay_in_minutes
  firewall_rules                       = var.synapse_firewall_rules
  tags                                 = var.tags
  sql_admin_password_secret_name       = var.synapse_sql_admin_password_secret_name
  key_vault_name                       = var.key_vault_name
}
