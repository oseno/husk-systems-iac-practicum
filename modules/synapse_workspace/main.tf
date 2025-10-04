resource "random_password" "sql_admin_password" {
  length  = 20
  special = true
  upper   = true
  numeric = true
}

resource "azurerm_synapse_workspace" "main" {
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = random_password.sql_admin_password.result # using generated password
  # password can be accessed through tofu output or key vault

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
  name                 = "${var.name}-sqlpool"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  sku_name              = var.sql_pool_sku
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  data_encrypted       = true
  storage_account_type = "LRS"
  create_mode          = "Default"


  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Spark pool configuration
resource "azurerm_synapse_spark_pool" "main" {
  name                 = "${var.name}-sparkpool"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  node_count           = var.spark_pool_node_count
  node_size_family     = var.spark_pool_node_size_family
  node_size            = var.spark_pool_node_size_family
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


