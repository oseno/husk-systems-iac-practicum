resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "${var.resource_prefix}-cpu-high-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.target_resource_id]


  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold_percent
  }

  window_size = "5m"
  frequency   = "1m"
  severity    = 2
  enabled     = true

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "cost_spike" {
  name                = "${var.resource_prefix}-cost-spike-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.subscription_id]

  criteria {
    metric_namespace = "Microsoft.CostManagement"
    metric_name      = "ActualCost"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.cost_spike_threshold
  }

  window_size = "1h"
  frequency   = "15m"
  severity    = 1

  action {
    action_group_id = var.action_group_id
  }
}
