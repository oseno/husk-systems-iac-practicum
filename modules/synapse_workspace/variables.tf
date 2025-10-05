variable "name" {
  description = "The name of the Synapse workspace."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource group where the synapse workspace should exsit."
  type        = string
}

variable "location" {
  description = "The Azure region where the Synapse workspace should be created."
  type        = string
}

variable "storage_data_lake_gen2_filesystem_id" {
  description = "The ID of the data lake storage gen2 filesystem (container) to be used by synapse."
  type        = string
}

variable "sql_administrator_login" {
  description = "The login name of the Synapse SQL administrator."
  type        = string
}

variable "managed_virtual_network_enabled" {
  description = "Specifies whether a managed virtual network is enabled for the Synapse workspace."
  type        = bool
  default     = true
}

variable "sql_pool_sku" {
  description = "The SKU for the Synapse SQL pool such as 'DW100c', 'DW200c'"
  type        = string
  default     = "DW100c"
}

variable "spark_pool_node_count" {
  description = "The number of nodes in the spark pool if auto_scale is disabled."
  type        = number
  default     = 3
}

variable "spark_pool_node_size_family" {
  description = "The node size family for the spark pool such as 'MemoryOptimized', 'None'"
  type        = string
  default     = "MemoryOptimized"
}

variable "spark_pool_node_size" {
  description = "The node size for the Spark pool such as 'Medium', 'Small'"
  type        = string
  default     = "Small"
}

variable "spark_pool_version" {
  description = "The Spark version for the Spark pool such as 3.4"
  type        = string
  default     = "3.4"
}

variable "spark_pool_auto_pause_enabled" {
  description = "Specifies whether Spark pool should auto-pause when idle."
  type        = bool
  default     = true
}

variable "spark_pool_auto_scale_enabled" {
  description = "Specifies whether auto-scaling is enabled for the Spark pool."
  type        = bool
  default     = true
}

variable "spark_pool_min_node_count" {
  description = "The minimum number of nodes for the Spark pool if auto-scaling is enabled."
  type        = number
  default     = 3
}

variable "spark_pool_max_node_count" {
  description = "The maximum number of nodes for the Spark pool if auto-scaling is enabled."
  type        = number
  default     = 10
}

variable "spark_pool_delay_in_minutes" {
  description = "The number of minutes of idle time before the Spark pool is automatically paused."
  type        = number
  default     = 15
}

variable "firewall_rules" {
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

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "storage_account_id" {
  description = "The ID of the Storage Account associated with the Synapse (for RBAC scope)."
  type        = string
}

variable "key_vault_name" {
  description = "The name of the Azure key vault containing the secrets."
  type        = string
}

variable "sql_admin_password_secret_name" {
  description = "The name of the secret in the key vault that stores the SQL admin password."
  type        = string
}
