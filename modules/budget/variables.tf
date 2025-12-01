variable "prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "amount" {
  type = number
}

variable "threshold_percentage" {
  type    = number
  default = 80
}

variable "start_date" {
  type = string
}

variable "end_date" {
  type = string
}

variable "contact_emails" {
  type = list(string)
}
