variable "name" {
  description = "The name of the Storage Account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Storage account should exist."
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account should be created"
  type        = string
}

variable "filesystem_name" {
  description = "The name of the primary filesystem (container) within the Data Lake account."
  type        = string
  default     = "synapsefs"
}

variable "tags" {
  description = "A map of tags to assign to the storage account."
  type        = map(string)
  default     = {}
}
