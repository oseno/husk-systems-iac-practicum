variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
  default     = "dev"
}

variable "subscription_id" {
  description = "Azure subscription ID for RBAC assignments"
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