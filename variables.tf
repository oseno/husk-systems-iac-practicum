variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "southindia"
}

variable "resource_group_name" {
  description = "Name of the existing resource group to deploy resources into"
  type        = string
  default     = "rg-prod-in-cmu"
}

variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "infracore"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    "Provisioner" = "OpenTofu"
    "Environment" = "dev"
  }
}

# ==========================================
# SQL Server Module Variables
# ==========================================
variable "sql_server_name" {
  description = "Name of the SQL server"
  type        = string
}

variable "sql_admin_login" {
  description = "SQL Server administrator login"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
}

variable "sql_db_telemetry_sku" {
  description = "SKU for Telemetry database"
  type        = string
}

variable "sql_db_telemetry_max_size_gb" {
  description = "Max size in GB for Telemetry database"
  type        = number
}

variable "sql_db_customer_sku" {
  description = "SKU for Customer database"
  type        = string
}

variable "sql_db_customer_max_size_gb" {
  description = "Max size in GB for Customer database"
  type        = number
}

variable "sql_db_analytics_sku" {
  description = "SKU for Analytics database"
  type        = string
}

variable "sql_db_analytics_max_size_gb" {
  description = "Max size in GB for Analytics database"
  type        = number
}

variable "sql_backup_retention_days" {
  description = "Backup retention in days for SQL databases"
  type        = number
}

variable "sql_backup_interval_hours" {
  description = "Backup interval in hours for SQL databases"
  type        = number
}

variable "sql_ltr_weekly_retention" {
  description = "Long-term weekly backup retention in weeks"
  type        = string
}

variable "sql_ltr_monthly_retention" {
  description = "Long-term monthly backup retention in months"
  type        = string
}

variable "sql_ltr_yearly_retention" {
  description = "Long-term yearly backup retention in years"
  type        = string
}

variable "sql_geo_backup_enabled" {
  description = "Enable geo-redundant backups"
  type        = bool
}

variable "sql_zone_redundant" {
  description = "Enable zone-redundant configuration"
  type        = bool
}

variable "sql_firewall_rules" {
  description = "A map of firewall rules (name, start_ip, end_ip) for the SQL server"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "sql_enable_auditing" {
  description = "Enable auditing on the SQL server"
  type        = bool
  default     = false
}

variable "sql_audit_storage_name" {
  description = "Storage account name for auditing logs"
  type        = string
  default     = ""
}

variable "sql_audit_retention_days" {
  description = "Retention in days for audit logs"
  type        = number
  default     = 0
}

variable "sql_enable_threat_detection" {
  description = "Enable threat detection on SQL server"
  type        = bool
  default     = false
}

variable "sql_threat_detection_emails" {
  description = "List of email addresses to notify for threat detection"
  type        = list(string)
  default     = []
}

variable "sql_enable_failover" {
  description = "Enable failover for SQL server"
  type        = bool
  default     = false
}

variable "sql_failover_location" {
  description = "Failover region for SQL server"
  type        = string
  default     = ""
}

variable "sql_failover_mode" {
  description = "Failover mode: Manual or Automatic"
  type        = string
  default     = "Manual"
}

variable "sql_failover_grace_minutes" {
  description = "Grace period in minutes for failover"
  type        = number
  default     = 60
}

# ==========================================
# Commented out variables (not needed)
# ==========================================

# Synapse / Spark variables
# variable "synapse_managed_vnet_enabled" {}
# variable "synapse_sql_pool_sku" {}
# variable "synapse_spark_pool_node_count" {}
# variable "synapse_spark_pool_node_size_family" {}
# variable "synapse_spark_pool_node_size" {}
# variable "synapse_spark_pool_version" {}
# variable "synapse_spark_pool_auto_pause_enabled" {}
# variable "synapse_spark_pool_auto_scale_enabled" {}
# variable "synapse_spark_pool_min_node_count" {}
# variable "synapse_spark_pool_max_node_count" {}
# variable "synapse_spark_pool_delay_in_minutes" {}
# variable "key_vault_name" {}
# variable "synapse_sql_admin_password_secret_name" {}

# Security / RBAC variables
# variable "subscription_id" {}
# variable "rbac_readers" {}
# variable "rbac_contributors" {}

# Databricks variables
# variable "databricks_cluster_policy_allowed_node_types" {}
# variable "databricks_autoscale_policy_enabled_name" {}
# variable "databricks_sku_name" {}
# variable "databricks_autoscale_policy_enabled_value" {}
# variable "databricks_autoscale_min_workers_value" {}
# variable "databricks_autoscale_max_min_workers_value" {}
# variable "databricks_autoscale_max_max_workers_value" {}
# variable "databricks_autotermination_minutes_maxValue" {}
# variable "databricks_autotermination_minutes_minValue" {}
# variable "databricks_spark_version" {}

# Monitoring / Alerts / Budgets variables
# variable "prefix" {}
# variable "alerts_email_address" {}
# variable "budget_monthly_amount" {}
# variable "budget_cost_alert_emails" {}
# variable "alerts_cost_spike_threshold" {}
