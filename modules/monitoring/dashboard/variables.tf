variable "prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}


variable "app_service_id" {
  type = string
}

variable "function_app_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "budget_amount" {
  type = number
}

variable "current_spend" {
  type = number
}

variable "tags" {
  type = map(string)
}
