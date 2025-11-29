variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "function_app_plan_name" {
  description = "Name of the Function App Service Plan"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account for Function App"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "os_type" {
  description = "Operating system type (Linux or Windows)"
  type        = string
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be either 'Linux' or 'Windows'."
  }
}

variable "sku_name" {
  description = "SKU name for Function App Plan (e.g., Y1 for Consumption, EP1 for Elastic Premium)"
  type        = string
  default     = "Y1"
}

variable "runtime" {
  description = "Runtime for Function App (python, node, dotnet, java)"
  type        = string
  default     = "python"

  validation {
    condition     = contains(["python", "node", "dotnet", "java", "powershell"], var.runtime)
    error_message = "Runtime must be one of: python, node, dotnet, java, powershell."
  }
}

variable "runtime_version" {
  description = "Runtime version (e.g., '3.11' for Python, '18' for Node, '6.0' for .NET)"
  type        = string
  default     = "3.11"
}

variable "always_on" {
  description = "Should the app be loaded at all times? (Not available for Consumption plan)"
  type        = bool
  default     = false
}

variable "application_insights_connection_string" {
  description = "Application Insights connection string"
  type        = string
  default     = null
}

variable "application_insights_key" {
  description = "Application Insights instrumentation key"
  type        = string
  default     = null
}

variable "app_settings" {
  description = "Application settings for the Function App"
  type        = map(string)
  default     = {}
}

variable "enable_autoscale" {
  description = "Enable autoscaling for the Function App Plan (only for Premium plans)"
  type        = bool
  default     = false
}

variable "autoscale_min_instances" {
  description = "Minimum number of instances for autoscale"
  type        = number
  default     = 1
}

variable "autoscale_max_instances" {
  description = "Maximum number of instances for autoscale"
  type        = number
  default     = 10
}

variable "autoscale_default_instances" {
  description = "Default number of instances"
  type        = number
  default     = 1
}

variable "enable_vnet_integration" {
  description = "Enable VNet integration for the Function App"
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "Subnet ID for VNet integration (required if enable_vnet_integration is true)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}