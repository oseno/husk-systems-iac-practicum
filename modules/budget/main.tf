data "azurerm_subscription" "current" {}

resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "${var.prefix}-${var.environment}-budget"
  resource_group_id = var.resource_group_id
  amount            = var.amount
  time_grain        = "Monthly"
  time_period {
    start_date = var.start_date
    end_date   = var.end_date
  }
  notification {
    enabled        = true
    threshold      = var.threshold_percentage
    operator       = "GreaterThan"
    contact_emails = var.contact_emails
    threshold_type = "Actual"
  }
}

resource "azurerm_consumption_budget_subscription" "name" {
  subscription_id = data.azurerm_subscription.current.id
  name            = "${var.prefix}-${var.environment}-budget"
  amount          = var.amount
  time_grain      = "Monthly"

  time_period {
    start_date = var.start_date
    end_date   = var.end_date
  }

  notification {
    enabled        = true
    threshold      = var.threshold_percentage
    operator       = "GreaterThan"
    contact_emails = var.contact_emails
    threshold_type = "Actual"
  }
}
