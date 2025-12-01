variable "resource_prefix" {
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

variable "target_resource_id" {
  type = string # will be the app service or function app id
}

variable "log_analytics_workspace_id" {
  type = string # for application insight logs
}

variable "action_group_id" {
  type = string
}

variable "cpu_threshold_percent" {
  type    = number
  default = 80
}

variable "ai_error_threshold" {
  type    = number
  default = 10
}

variable "subscription_id" {
  type = string
}

variable "cost_spike_threshold" {
  type = number
}

variable "tags" {
  type = map(string)
}

