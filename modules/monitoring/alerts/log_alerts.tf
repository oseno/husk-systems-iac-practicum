resource "azurerm_monitor_scheduled_query_rules_alert_v2" "appinsights_errors" {
  name                = "${var.resource_prefix}-ai-errors-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  severity            = 2
  enabled             = true
  description         = "Triggerd when application insights reports more than ${var.ai_error_threshold} errors in 5 mins"

  scopes = [var.log_analytics_workspace_id]

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  criteria {
    query                   = <<-QUERY
        traces
        | where severityLevel >= 3
        | where timestamp > ago(5m)
        QUERY
    time_aggregation_method = "Count"
    metric_measure_column   = "ErrorCount"
    operator                = "GreaterThan"
    threshold               = var.ai_error_threshold
  }

  action {
    action_groups = [var.action_group_id]
  }

  tags = var.tags
}
