variable "name" {
  description = "The name of the Databricks workspace."
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

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "allowed_node_types" {
  description = "Allowed VM SKUs for databricks clusters."
  type        = list(string)
  default = [
    "Standard_D4ds_v4",
    "Standard_D8ds_v4",
    "Standard_E4ds_v4"
  ]
}

variable "key_vault_name" {
  description = "The name of the Azure key vault containing the secrets."
  type        = string
}

variable "key_vault_secret_scope_name" {
  description = "The name of the secret scope in Databricks."
  type        = string
}

variable "autoscale_policy_enabled_name" {
  description = "The name of the autoscale policy in Databricks."
  type        = string
}

variable "sku_name" {
  description = "The SKUs for the Databricks workspace such as 'Premium '."
  type        = string
  default     = "Premium" # for governance features (Audit logs, RBAC)
}

variable "autoscale_policy_enabled_value" {
  description = "Specifies whether auto-scaling is enabled."
  type        = bool
  default     = true
}

variable "autoscale_min_workers_value" {
  description = "The minimum number of workers for the Databricks clusters if auto-scaling is enabled."
  type        = number
  default     = 1
}

variable "autoscale_max_min_workers_value" {
  # Assumes that autoscale for maximum workers is of type "range".
  description = "The minimum number of maximum workers for the Databricks clusters if auto-scaling is enabled."
  type        = number
  default     = 2
}

variable "autoscale_max_max_workers_value" {
  # Assumes that autoscale for maximum workers is of type "range".
  description = "The maximum number of maximum workers for the Databricks clusters if auto-scaling is enabled."
  type        = number
  default     = 15
}

variable "autotermination_minutes_maxValue" {
  # Assumes that autotermination minutes is of type "range".
  description = "The maximum number minutes before idle workers are terminated."
  type        = number
  default     = 60
}

variable "autotermination_minutes_minValue" {
  # Assumes that autotermination minutes is of type "range".
  description = "The minimum number minutes before idle workers are terminated."
  type        = number
  default     = 10
}

# Project/Environment Tags
variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
  default     = "dev" # shorter version of environment name
}

variable "spark_version" {
  type = number
}
