data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_subscription" "current" {}

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

module "databricks_workspace" {
  source = "./modules/databricks_workspace"

  name                             = "${var.environment}-${var.project_name}-databricks"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  environment                      = var.environment
  allowed_node_types               = var.databricks_cluster_policy_allowed_node_types
  key_vault_secret_scope_name      = "${var.environment}-${var.project_name}-kv-scope"
  key_vault_name                   = var.key_vault_name
  sku_name                         = var.databricks_sku_name
  autoscale_max_max_workers_value  = var.databricks_autoscale_max_max_workers_value
  autoscale_max_min_workers_value  = var.databricks_autoscale_max_min_workers_value
  autoscale_min_workers_value      = var.databricks_autoscale_min_workers_value
  autotermination_minutes_maxValue = var.databricks_autotermination_minutes_maxValue
  autotermination_minutes_minValue = var.databricks_autotermination_minutes_minValue
  autoscale_policy_enabled_name    = var.databricks_autoscale_policy_enabled_name
  autoscale_policy_enabled_value   = var.databricks_autoscale_policy_enabled_value
  spark_version                    = var.databricks_spark_version
  tags                             = var.tags
}

module "log_analytics" {
  source = "./modules/monitoring/log_analytics_workspace"

  workspace_name      = "la-${var.environment}-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = 30
  tags                = var.tags
}

module "app_insights" {
  source = "./modules/monitoring/app_insights"

  ai_name                    = "ai-${var.environment}-${var.prefix}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = module.log_analytics.workspace_id
  tags                       = var.tags
}

locals {
  # APP SERVICE
  # will use this in the App Service
  ai_connection_string = module.app_insights.app_insights_connection_string
}

resource "azurerm_monitor_action_group" "global" {
  name                = "${var.prefix}-${var.environment}-ag"
  resource_group_name = var.resource_group_name
  location            = "Global"

  email_receiver {
    name                    = "PrimaryEmail"
    email_address           = var.alerts_email_address
    use_common_alert_schema = true
  }

  short_name = "alert_email"

  tags = var.tags
}

module "alerts_app" {
  source = "./modules/monitoring/alerts"

  resource_prefix            = var.prefix
  environment                = var.environment
  resource_group_name        = var.resource_group_name
  location                   = var.location
  subscription_id            = data.azurerm_subscription.current.id
  cost_spike_threshold       = var.alerts_cost_spike_threshold
  target_resource_id         = module.storage_account.id # REPLACE THIS WITH APP SERVICE ID
  log_analytics_workspace_id = module.log_analytics.workspace_id
  action_group_id            = azurerm_monitor_action_group.global.id
  tags                       = var.tags
}

module "alerts_func" {
  source = "./modules/monitoring/alerts"

  resource_prefix            = var.prefix
  environment                = var.environment
  resource_group_name        = var.resource_group_name
  location                   = var.location
  subscription_id            = data.azurerm_subscription.current.id
  cost_spike_threshold       = var.alerts_cost_spike_threshold
  target_resource_id         = module.storage_account.id # REPLACE WITH FUNCTION APP ID
  log_analytics_workspace_id = module.log_analytics.workspace_id
  action_group_id            = azurerm_monitor_action_group.global.id
  tags                       = var.tags
}

module "budget" {
  source = "./modules/budget"

  prefix            = var.prefix
  environment       = var.environment
  resource_group_id = data.azurerm_resource_group.main.id
  amount            = var.budget_monthly_amount
  start_date        = "2025-01-01T00:00:00Z"
  end_date          = "2025-11-11T00:00:00Z"
  contact_emails    = var.budget_cost_alert_emails
}

module "dashboard" {
  source = "./modules/monitoring/dashboard"

  prefix                     = var.prefix
  environment                = var.environment
  resource_group_name        = var.resource_group_name
  location                   = var.location
  app_service_id             = module.storage_account.id # REPLACE WITH APP SERVICE ID
  function_app_id            = module.storage_account.id # REPLACE WITH FUNCTION APP ID
  log_analytics_workspace_id = module.log_analytics.workspace_id
  budget_amount              = var.budget_monthly_amount
  current_spend              = 0
  tags                       = var.tags
}
# # Stream Analytics Module to be used once permissions are made available
# module "stream_analytics" {
#   source = "./modules/stream_analytics"

#   name                = "${var.environment}-${var.project_name}-stream"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = var.location
#   streaming_units     = 3
  
#   transformation_query = <<QUERY
#     SELECT
#         *
#     INTO
#         [output]
#     FROM
#         [input]
#   QUERY

#   tags = var.tags
# }
