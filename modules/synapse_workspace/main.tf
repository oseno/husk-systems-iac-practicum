data "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name # assuming the key vault are in the same RG as the other resources
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = var.sql_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_synapse_workspace" "main" {
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = data.azurerm_key_vault_secret.sql_admin_password.value # use kv password

  # Basic identity configuration
  identity {
    type = "SystemAssigned" # for managed service identity (msi)
  }

  # enable managed virtual network
  managed_virtual_network_enabled = var.managed_virtual_network_enabled

  tags = var.tags
}

# SQL pool configuration
resource "azurerm_synapse_sql_pool" "main" {
  name                      = "${replace(var.name, "-", "_")}_sqlpool" # limit is 60 chars
  synapse_workspace_id      = azurerm_synapse_workspace.main.id
  sku_name                  = var.sql_pool_sku
  collation                 = "SQL_Latin1_General_CP1_CI_AS"
  data_encrypted            = true
  storage_account_type      = "LRS"
  geo_backup_policy_enabled = false # LRS is set so this is false
  create_mode               = "Default"


  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Spark pool configuration
resource "azurerm_synapse_spark_pool" "main" {
  name                 = "${substr(var.name, 0, 2)}sparkpool" # limit is 15 chars
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  node_count           = var.spark_pool_node_count
  node_size_family     = var.spark_pool_node_size_family
  node_size            = var.spark_pool_node_size
  spark_version        = var.spark_pool_version

  # set auto pause if enabled
  dynamic "auto_pause" {
    for_each = var.spark_pool_auto_pause_enabled ? [1] : []
    content {
      delay_in_minutes = var.spark_pool_delay_in_minutes
    }
  }

  # set auto scale if enabled 
  dynamic "auto_scale" {
    for_each = var.spark_pool_auto_scale_enabled ? [1] : []
    content {
      max_node_count = var.spark_pool_max_node_count
      min_node_count = var.spark_pool_min_node_count
    }
  }

  tags = var.tags
}

# Firewall rules
resource "azurerm_synapse_firewall_rule" "rules" {
  for_each             = var.firewall_rules
  name                 = each.key
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  start_ip_address     = each.value.start_ip
  end_ip_address       = each.value.end_ip
}


