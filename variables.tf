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
