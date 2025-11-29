variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "Name of the App Service"
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
  description = "SKU name for App Service Plan (e.g., B1, S1, P1v2)"
  type        = string
  default     = "B1"
}

variable "runtime_stack" {
  description = "Runtime stack (e.g., 'PYTHON|3.11', 'NODE|18-lts', 'DOTNET|6.0')"
  type        = string
  default     = "PYTHON|3.11"
}

variable "always_on" {
  description = "Should the app be loaded at all times?"
  type        = bool
  default     = true
}

variable "app_settings" {
  description = "Application settings for the App Service"
  type        = map(string)
  default     = {}
}

variable "enable_autoscale" {
  description = "Enable autoscaling for the App Service Plan"
  type        = bool
  default     = true
}

variable "autoscale_min_instances" {
  description = "Minimum number of instances for autoscale"
  type        = number
  default     = 1
}

variable "autoscale_max_instances" {
  description = "Maximum number of instances for autoscale"
  type        = number
  default     = 5
}

variable "autoscale_default_instances" {
  description = "Default number of instances"
  type        = number
  default     = 2
}

variable "enable_vnet_integration" {
  description = "Enable VNet integration for the App Service"
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