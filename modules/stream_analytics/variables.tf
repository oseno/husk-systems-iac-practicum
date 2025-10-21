variable "name" {
  description = "Name of the Stream Analytics job"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the Stream Analytics job"
  type        = string
}

variable "streaming_units" {
  description = "Number of streaming units (1, 3, 6, 12, etc.)"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply to the Stream Analytics job"
  type        = map(string)
  default     = {}
}

variable "transformation_query" {
  description = "Stream Analytics transformation query"
  type        = string
}