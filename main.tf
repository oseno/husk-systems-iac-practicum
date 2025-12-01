data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_subscription" "current" {}

# Add common_tags local variable needed by sql_server module
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

# module "storage_account" {
#   source = "./modules/storage_account"
#
#   name                = "${var.environment}${var.project_name}sa${random_string.suffix.result}"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = var.location
#   filesystem_name     = "${var.project_name}-${var.environment}-fs"
#   tags                = var.tags
# }

# resource "random_string" "suffix" {
#   length  = 6
#   special = false
#   upper   = false
#   numeric = true
# }

# module "synapse_workspace" {
#   source = "./modules/synapse_workspace"
#
#   name                                 = "${var.environment}-${var.project_name}-synapse"
#   resource_group_name                  = data.azurerm_resource_group.main.name
#   location                             = var.location
#   storage_data_lake_gen2_filesystem_id = module.storage_account.filesystem_synapse_url
#   storage_account_id                   = module.storage_account.id
#   sql_administrator_login              = var.sql_administrator_login
#   managed_virtual_network_enabled      = var.synapse_managed_vnet_enabled
#   sql_pool_sku                         = var.synapse_sql_pool_sku
#   spark_pool_node_count                = var.synapse_spark_pool_node_count
#   spark_pool_node_size_family          = var.synapse_spark_pool_node_size_family
#   spark_pool_node_size                 = var.synapse_spark_pool_node_size
#   spark_pool_version                   = var.synapse_spark_pool_version
#   spark_pool_auto_pause_enabled        = var.synapse_spark_pool_auto_pause_enabled
#   spark_pool_auto_scale_enabled        = var.synapse_spark_pool_auto_scale_enabled
#   spark_pool_min_node_count            = var.synapse_spark_pool_min_node_count
#   spark_pool_max_node_count            = var.synapse_spark_pool_max_node_count
#   spark_pool_delay_in_minutes          = var.synapse_spark_pool_delay_in_minutes
#   firewall_rules                       = var.synapse_firewall_rules
#   tags                                 = var.tags
#   sql_admin_password_secret_name       = var.synapse_sql_admin_password_secret_name
#   key_vault_name                       = var.key_vault_name
# }

# Security Hardening Module
# module "security" {
#   source = "./modules/security"
#
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = var.location
#   environment         = var.environment
#   subscription_id     = var.subscription_id
#
#   rbac_readers      = var.rbac_readers
#   rbac_contributors = var.rbac_contributors
# }

# Stream Analytics Module
# module "stream_analytics" {
#   source = "./modules/stream_analytics"
#
#   name                = "${var.environment}-${var.project_name}-stream"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = var.location
#   streaming_units     = 3
#   
#   transformation_query = <<QUERY
#     SELECT
#         *
#     INTO
#         [output]
#     FROM
#         [input]
#   QUERY
#
#   tags = var.tags
# }

# Databricks Module
# module "databricks_workspace" {
#   source = "./modules/databricks_workspace"
#
#   name                             = "${var.environment}-${var.project_name}-databricks"
#   resource_group_name              = var.resource_group_name
#   location                         = var.location
#   environment                      = var.environment
#   allowed_node_types               = var.databricks_cluster_policy_allowed_node_types
#   key_vault_secret_scope_name      = "${var.environment}-${var.project_name}-kv-scope"
#   key_vault_name                   = var.key_vault_name
#   sku_name                         = var.databricks_sku_name
#   autoscale_max_max_workers_value  = var.databricks_autoscale_max_max_workers_value
#   autoscale_max_min_workers_value  = var.databricks_autoscale_max_min_workers_value
#   autoscale_min_workers_value      = var.databricks_autoscale_min_workers_value
#   autotermination_minutes_maxValue = var.databricks_autotermination_minutes_maxValue
#   autotermination_minutes_minValue = var.databricks_autotermination_minutes_minValue
#   autoscale_policy_enabled_name    = var.databricks_autoscale_policy_enabled_name
#   autoscale_policy_enabled_value   = var.databricks_autoscale_policy_enabled_value
#   spark_version                    = var.databricks_spark_version
#   tags                             = var.tags
# }

# Log Analytics Module
# module "log_analytics" {
#   source = "./modules/monitoring/log_analytics_workspace"
#
#   workspace_name      = "la-${var.environment}-${var.prefix}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   retention_in_days   = 30
#   tags                = var.tags
# }

# Application Insights Module
# module "app_insights" {
#   source = "./modules/monitoring/app_insights"
#
#   ai_name                    = "ai-${var.environment}-${var.prefix}"
#   location                   = var.location
#   resource_group_name        = var.resource_group_name
#   log_analytics_workspace_id = module.log_analytics.workspace_id
#   tags                       = var.tags
# }

# locals {
#   ai_connection_string = module.app_insights.app_insights_connection_string
# }

# Action Group
# resource "azurerm_monitor_action_group" "global" {
#   name                = "${var.prefix}-${var.environment}-ag"
#   resource_group_name = var.resource_group_name
#   location            = "Global"
#
#   email_receiver {
#     name                    = "PrimaryEmail"
#     email_address           = var.alerts_email_address
#     use_common_alert_schema = true
#   }
#
#   short_name = "alert_email"
#
#   tags = var.tags
# }

# Alerts for App Service
# module "alerts_app" {
#   source = "./modules/monitoring/alerts"
#
#   resource_prefix            = var.prefix
#   environment                = var.environment
#   resource_group_name        = var.resource_group_name
#   location                   = var.location
#   subscription_id            = data.azurerm_subscription.current.id
#   cost_spike_threshold       = var.alerts_cost_spike_threshold
#   target_resource_id         = module.storage_account.id # REPLACE THIS WITH APP SERVICE ID
#   log_analytics_workspace_id = module.log_analytics.workspace_id
#   action_group_id            = azurerm_monitor_action_group.global.id
#   tags                       = var.tags
# }

# Alerts for Function App
# module "alerts_func" {
#   source = "./modules/monitoring/alerts"
#
#   resource_prefix            = var.prefix
#   environment                = var.environment
#   resource_group_name        = var.resource_group_name
#   location                   = var.location
#   subscription_id            = data.azurerm_subscription.current.id
#   cost_spike_threshold       = var.alerts_cost_spike_threshold
#   target_resource_id         = module.storage_account.id # REPLACE WITH FUNCTION APP ID
#   log_analytics_workspace_id = module.log_analytics.workspace_id
#   action_group_id            = azurerm_monitor_action_group.global.id
#   tags                       = var.tags
# }

# Budget Module
# module "budget" {
#   source = "./modules/budget"
#
#   prefix            = var.prefix
#   environment       = var.environment
#   resource_group_id = data.azurerm_resource_group.main.id
#   amount            = var.budget_monthly_amount
#   start_date        = "2025-01-01T00:00:00Z"
#   end_date          = "2025-11-11T00:00:00Z"
#   contact_emails    = var.budget_cost_alert_emails
# }

# Dashboard Module
# module "dashboard" {
#   source = "./modules/monitoring/dashboard"
#
#   prefix                     = var.prefix
#   environment                = var.environment
#   resource_group_name        = var.resource_group_name
#   location                   = var.location
#   app_service_id             = module.storage_account.id # REPLACE WITH APP SERVICE ID
#   function_app_id            = module.storage_account.id # REPLACE WITH FUNCTION APP ID
#   log_analytics_workspace_id = module.log_analytics.workspace_id
#   budget_amount              = var.budget_monthly_amount
#   current_spend              = 0
#   tags                       = var.tags
# }

# ==========================================
# SQL SERVER MODULE - ACTIVE
# ==========================================
module "sql_server" {
  source = "./modules/sql_server"
  
  sql_server_name     = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sql_admin_login     = var.sql_admin_login
  sql_admin_password  = var.sql_admin_password
  
  databases = {
    telemetry = {
      name                     = "sqldb-${var.environment}-ng-cmu-telemetry"
      sku_name                 = var.sql_db_telemetry_sku
      max_size_gb              = var.sql_db_telemetry_max_size_gb
      backup_retention_days    = var.sql_backup_retention_days
      backup_interval_hours    = var.sql_backup_interval_hours
      enable_ltr               = true
      ltr_weekly_retention     = var.sql_ltr_weekly_retention
      ltr_monthly_retention    = var.sql_ltr_monthly_retention
      ltr_yearly_retention     = var.sql_ltr_yearly_retention
      ltr_week_of_year         = 1
      geo_backup_enabled       = var.sql_geo_backup_enabled
      tde_enabled              = true
      zone_redundant           = var.sql_zone_redundant
      tags                     = { Database = "Telemetry" }
    }
    customer = {
      name                     = "sqldb-${var.environment}-ng-cmu-customer"
      sku_name                 = var.sql_db_customer_sku
      max_size_gb              = var.sql_db_customer_max_size_gb
      backup_retention_days    = var.sql_backup_retention_days
      backup_interval_hours    = var.sql_backup_interval_hours
      enable_ltr               = true
      ltr_weekly_retention     = var.sql_ltr_weekly_retention
      ltr_monthly_retention    = var.sql_ltr_monthly_retention
      ltr_yearly_retention     = var.sql_ltr_yearly_retention
      ltr_week_of_year         = 1
      geo_backup_enabled       = var.sql_geo_backup_enabled
      tde_enabled              = true
      zone_redundant           = var.sql_zone_redundant
      tags                     = { Database = "Customer" }
    }
    analytics = {
      name                     = "sqldb-${var.environment}-ng-cmu-analytics"
      sku_name                 = var.sql_db_analytics_sku
      max_size_gb              = var.sql_db_analytics_max_size_gb
      backup_retention_days    = var.sql_backup_retention_days
      backup_interval_hours    = var.sql_backup_interval_hours
      enable_ltr               = true
      ltr_weekly_retention     = var.sql_ltr_weekly_retention
      ltr_monthly_retention    = var.sql_ltr_monthly_retention
      ltr_yearly_retention     = var.sql_ltr_yearly_retention
      ltr_week_of_year         = 1
      geo_backup_enabled       = var.sql_geo_backup_enabled
      tde_enabled              = true
      zone_redundant           = var.sql_zone_redundant
      tags                     = { Database = "Analytics" }
    }
  }
  
  firewall_rules = var.sql_firewall_rules
  
  enable_auditing            = var.sql_enable_auditing
  audit_storage_account_name = var.sql_audit_storage_name
  audit_retention_days       = var.sql_audit_retention_days
  
  enable_threat_detection          = var.sql_enable_threat_detection
  threat_detection_email_addresses = var.sql_threat_detection_emails
  
  enable_failover        = var.sql_enable_failover
  failover_location      = var.sql_failover_location
  failover_mode          = var.sql_failover_mode
  failover_grace_minutes = var.sql_failover_grace_minutes
  
  tags = local.common_tags
}
