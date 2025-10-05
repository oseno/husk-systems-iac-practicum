variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "jioindiawest" # India Pacific since they are located in India
}

# Resource Group
variable "resource_group_name" {
  description = "Name of the existing resource group to deploy resources into"
  type        = string
  default     = "rg-prod-ng-cmu" # cannot hardcode this since you only use it while creating
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
  default     = "InfraCore"
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

