variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "southindia"
}

# Resource Group
variable "resource_group_name" {
  description = "Name of the existing resource group to deploy resources into"
  type        = string
  default     = "rg-prod-in-cmu" # cannot hardcode this since you only use it while creating
  # a test storage account. What if the resource group does not exist?
}

# Project/Environment Tags
variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
  default     = "dev" # shorter version of environment name
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "infracore"  # Changed to lowercase
}

variable "owner" {
  description = "Owner/team name for tagging"
  type        = string
  default     = "InfraCore Team"
}

# Test Resource Configuration
variable "test_storage_name_prefix" {
  description = "Prefix for test storage account name"
  type        = string
  default     = "sadevngcmutest"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    "Provisioner" = "OpenTofu"
    "Environment" = "dev" # default but will be overriden by envs
  }
}

variable "sql_administrator_login" {
  description = "The SQL administrator login for the Synapse workspace."
  type        = string
}

variable "synapse_managed_vnet_enabled" {
  description = "Specifies whether a managed virtual network is enabled for the Synapse workspace."
  type        = bool
  default     = true
}

variable "synapse_sql_pool_sku" {
  description = "The SKU for Synapse workspace such as 'DW100c'"
  type        = string
  default     = "DW100c"
}

variable "synapse_spark_pool_node_count" {
  description = "The number of node in the Spark pool if auto-scale is disabled."
  type        = number
  default     = 3
}

variable "synapse_spark_pool_node_size_family" {
  description = "The node size family for the spark pool such as 'MemoryOptimized', 'None'."
  type        = string
  default     = "MemoryOptimized"
}

variable "synapse_spark_pool_node_size" {
  description = "The node size for the spark pool such as 'Medium', 'Small'."
  type        = string
  default     = "Small"
}

variable "synapse_spark_pool_version" {
  description = "The Spark version for the Spark pool such as 3.4"
  type        = string
  default     = "3.4"
}

variable "synapse_spark_pool_auto_pause_enabled" {
  description = "Specifies whether Spark pool should auto-pause when idle."
  type        = bool
  default     = true
}

variable "synapse_spark_pool_auto_scale_enabled" {
  description = "Specifies whether auto-scaling is enabled for the Spark pool. "
  type        = bool
  default     = true
}

variable "synapse_spark_pool_min_node_count" {
  description = "The minimum number of nodes for the Spark pool if auto-scale is enabled."
  type        = number
  default     = 3
}

variable "synapse_spark_pool_max_node_count" {
  description = "The maximum number of nodes for the Spark pool if auto-scale is enabled."
  type        = number
  default     = 10
}

variable "synapse_spark_pool_delay_in_minutes" {
  description = "The number of minutes of idle time before the Spark pool is automatically paused."
  type        = number
  default     = 15
}

variable "synapse_firewall_rules" {
  description = "A map of firewall rules (name, start_ip, end_ip) for the Synapse workspace."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {
    "AllowAzureServices" = {
      start_ip = "0.0.0.0"
      end_ip   = "0.0.0.0"
    }
  }
}

variable "key_vault_name" {
  description = "The name of the Azure key vault containing the Synapse credentials."
  type        = string
}

variable "synapse_sql_admin_password_secret_name" {
  description = "The name of the secret in Key vault that stores the SQL admin password."
  type        = string
  default     = "synapse-sql-admin-password"
}

# Security Module Variables
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "rbac_readers" {
  description = "List of principal IDs to assign Reader role"
  type        = list(string)
  default     = []
}

variable "rbac_contributors" {
  description = "List of principal IDs to assign Contributor role"
  type        = list(string)
  default     = []
}
variable "databricks_cluster_policy_allowed_node_types" {
  description = "Allowed VM SKUs for databricks clusters."
  type        = list(string)
  default = [
    "Standard_D4ds_v4",
    "Standard_D8ds_v4",
    "Standard_E4ds_v4"
  ]
}



variable "databricks_autoscale_policy_enabled_name" {
  description = "The name of the autoscale policy in Databricks."
  type        = string
}

variable "databricks_sku_name" {
  description = "The SKUs for the Databricks workspace such as 'Premium '."
  type        = string
  default     = "premium" # for governance features (Audit logs, RBAC)
}

variable "databricks_autoscale_policy_enabled_value" {
  description = "Specifies whether auto-scaling is enabled."
  type        = bool
  default     = true
}

variable "databricks_autoscale_min_workers_value" {
  description = "The minimum number of workers for the Databricks clusters if auto-scaling is enabled."
  type        = number
  default     = 1
}

variable "databricks_autoscale_max_min_workers_value" {
  # Assumes that autoscale for maximum workers is of type "range".
  description = "The minimum number of maximum workers for the Databricks clusters if auto-scaling is enabled."
  type        = number
  default     = 2
}

variable "databricks_autoscale_max_max_workers_value" {
  # Assumes that autoscale for maximum workers is of type "range".
  description = "The maximum number of maximum workers for the Databricks clusters if auto-scaling is enabled."
  type        = number
  default     = 15
}

variable "databricks_autotermination_minutes_maxValue" {
  # Assumes that autotermination minutes is of type "range".
  description = "The maximum number minutes before idle workers are terminated."
  type        = number
  default     = 60
}

variable "databricks_autotermination_minutes_minValue" {
  # Assumes that autotermination minutes is of type "range".
  description = "The minimum number minutes before idle workers are terminated."
  type        = number
  default     = 10
}

variable "databricks_spark_version" {
  type = string
}

variable "prefix" {
  type = string
}

variable "alerts_email_address" {
  type = string
}

variable "budget_monthly_amount" {
  type = number
}

variable "budget_cost_alert_emails" {
  type = list(string)
}

variable "alerts_cost_spike_threshold" {
  type = number
}

# ==========================================
# SQL SERVER VARIABLES
# Add these to the END of your variables.tf file
# ==========================================

variable "sql_server_name" {
  description = "Name of the SQL Server (must be globally unique)"
  type        = string
}

variable "sql_admin_login" {
  description = "SQL Server administrator login"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

# Database SKUs
variable "sql_db_telemetry_sku" {
  description = "SKU for telemetry database"
  type        = string
  default     = "Basic"
}

variable "sql_db_customer_sku" {
  description = "SKU for customer database"
  type        = string
  default     = "Basic"
}

variable "sql_db_analytics_sku" {
  description = "SKU for analytics database"
  type        = string
  default     = "Basic"
}

# Database Sizes
variable "sql_db_telemetry_max_size_gb" {
  description = "Max size in GB for telemetry database"
  type        = number
  default     = 2
}

variable "sql_db_customer_max_size_gb" {
  description = "Max size in GB for customer database"
  type        = number
  default     = 2
}

variable "sql_db_analytics_max_size_gb" {
  description = "Max size in GB for analytics database"
  type        = number
  default     = 2
}

# Backup Configuration
variable "sql_backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "sql_backup_interval_hours" {
  description = "Backup interval in hours"
  type        = number
  default     = 12
}

# Long-term Retention
variable "sql_ltr_weekly_retention" {
  description = "Weekly backup retention (e.g., P4W for 4 weeks)"
  type        = string
  default     = "P1W"
}

variable "sql_ltr_monthly_retention" {
  description = "Monthly backup retention (e.g., P12M for 12 months)"
  type        = string
  default     = "P1M"
}

variable "sql_ltr_yearly_retention" {
  description = "Yearly backup retention (e.g., P5Y for 5 years)"
  type        = string
  default     = "P1Y"
}

# Geo-backup and Redundancy
variable "sql_geo_backup_enabled" {
  description = "Enable geo-backup"
  type        = bool
  default     = false
}

variable "sql_zone_redundant" {
  description = "Enable zone redundancy"
  type        = bool
  default     = false
}

# Firewall Rules
variable "sql_firewall_rules" {
  description = "Map of firewall rules for SQL Server"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

# Auditing
variable "sql_enable_auditing" {
  description = "Enable SQL Server auditing"
  type        = bool
  default     = false
}

variable "sql_audit_storage_name" {
  description = "Storage account name for audit logs (must be globally unique)"
  type        = string
  default     = ""
}

variable "sql_audit_retention_days" {
  description = "Audit log retention days"
  type        = number
  default     = 90
}

# Threat Detection
variable "sql_enable_threat_detection" {
  description = "Enable threat detection"
  type        = bool
  default     = false
}

variable "sql_threat_detection_emails" {
  description = "Email addresses for threat alerts"
  type        = list(string)
  default     = []
}

# Failover Configuration
variable "sql_enable_failover" {
  description = "Enable failover group"
  type        = bool
  default     = false
}

variable "sql_failover_location" {
  description = "Secondary region for failover"
  type        = string
  default     = "eastus"
}

variable "sql_failover_mode" {
  description = "Failover mode (Automatic or Manual)"
  type        = string
  default     = "Automatic"
}

variable "sql_failover_grace_minutes" {
  description = "Grace period for automatic failover"
  type        = number
  default     = 60
}


# ==========================================
# STREAM ANALYTICS CONFIGURATION
# Add these to the END of your variables.tf file
# ==========================================

variable "input_type" {
  description = "Input type for Stream Analytics"
  type        = string
  default     = "eventhub"
}

variable "eventhub_namespace_name" {
  description = "Event Hub namespace name"
  type        = string
}

variable "eventhub_name" {
  description = "Event Hub name"
  type        = string
}

variable "eventhub_partition_count" {
  description = "Event Hub partition count"
  type        = number
  default     = 4
}

variable "eventhub_message_retention" {
  description = "Event Hub message retention in days"
  type        = number
  default     = 1
}

variable "input_consumer_group" {
  description = "Input consumer group"
  type        = string
  default     = "$Default"
}

variable "input_serialization_type" {
  description = "Input serialization type"
  type        = string
  default     = "Json"
}

variable "input_serialization_encoding" {
  description = "Input serialization encoding"
  type        = string
  default     = "UTF8"
}

variable "output_type" {
  description = "Output type for Stream Analytics"
  type        = string
  default     = "blob"
}

variable "output_blob_container" {
  description = "Output blob container name"
  type        = string
}

variable "output_blob_path_pattern" {
  description = "Output blob path pattern"
  type        = string
}

variable "output_blob_date_format" {
  description = "Output blob date format"
  type        = string
  default     = "yyyy-MM-dd"
}

variable "output_blob_time_format" {
  description = "Output blob time format"
  type        = string
  default     = "HH"
}

variable "output_serialization_type" {
  description = "Output serialization type"
  type        = string
  default     = "Json"
}

variable "output_serialization_format" {
  description = "Output serialization format"
  type        = string
  default     = "LineSeparated"
}

variable "output_batch_size" {
  description = "Output batch size"
  type        = number
  default     = 100
}

variable "transformation_window_type" {
  description = "Transformation window type"
  type        = string
  default     = "tumbling"
}

variable "transformation_window_duration" {
  description = "Transformation window duration"
  type        = string
  default     = "5 minute"
}

variable "transformation_hop_size" {
  description = "Transformation hop size"
  type        = string
  default     = "1 minute"
}

variable "transformation_aggregate_functions" {
  description = "Transformation aggregate functions"
  type        = list(string)
  default     = ["AVG", "MAX", "MIN", "COUNT"]
}

variable "transformation_filter_condition" {
  description = "Transformation filter condition"
  type        = string
  default     = ""
}

variable "transformation_group_by_fields" {
  description = "Transformation group by fields"
  type        = list(string)
  default     = ["DeviceId"]
}

variable "transformation_partition_by" {
  description = "Transformation partition by"
  type        = string
  default     = "DeviceId"
}

variable "transformation_out_of_order_tolerance" {
  description = "Transformation out of order tolerance"
  type        = number
  default     = 5
}

variable "transformation_late_arrival_tolerance" {
  description = "Transformation late arrival tolerance"
  type        = number
  default     = 5
}

variable "transformation_output_error_policy" {
  description = "Transformation output error policy"
  type        = string
  default     = "Drop"
}

variable "stream_analytics_job_name" {
  description = "Stream Analytics job name"
  type        = string
}

variable "streaming_units" {
  description = "Streaming units"
  type        = number
  default     = 3
}

variable "compatibility_level" {
  description = "Compatibility level"
  type        = string
  default     = "1.2"
}

variable "auto_start_stream_job" {
  description = "Auto start stream job"
  type        = bool
  default     = false
}

variable "job_start_mode" {
  description = "Job start mode"
  type        = string
  default     = "JobStartTime"
}

variable "enable_diagnostics" {
  description = "Enable diagnostics"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log retention days"
  type        = number
  default     = 30
}

variable "enable_metric_alerts" {
  description = "Enable metric alerts"
  type        = bool
  default     = true
}

variable "error_alert_threshold" {
  description = "Error alert threshold"
  type        = number
  default     = 0
}

variable "alert_severity" {
  description = "Alert severity"
  type        = number
  default     = 1
}

# Synapse variables (you have sql_administrator_login but might need password)
variable "synapse_sql_admin_login" {
  description = "Synapse SQL admin login"
  type        = string
  default     = "sqladmin"
}

variable "synapse_sql_admin_password" {
  description = "Synapse SQL admin password"
  type        = string
  sensitive   = true
}

variable "ARM_STORAGE_ACCOUNT_KEY" {
  type        = string
  description = "Storage account key for backend"
  sensitive   = true
}
