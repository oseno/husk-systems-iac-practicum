variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

# Resource Group
variable "resource_group_name" {
  description = "Name of the existing resource group to deploy resources into"
  type        = string
  default     = "rg-prod-ng-cmu"
}

# Project/Environment Tags
variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
  default     = "development"
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

variable "synapse_sql_admin_login" {
  description = "SQL Administrator login for Synapse"
  type        = string
  default     = "sqladmin"
}

variable "synapse_sql_admin_password" {
  description = "SQL Administrator password for Synapse"
  type        = string
  sensitive   = true
}