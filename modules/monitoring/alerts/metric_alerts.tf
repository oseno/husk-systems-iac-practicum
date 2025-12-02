resource "azurerm_monitor_metric_alert" "http_5xx_errors" {
  name                = "${var.resource_prefix}-5xx-errors-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.target_resource_id]


  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx" # switched to http 500 error from the app service
    aggregation      = "Total"   # switched to total to received the total number of errors from the app service
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold_percent
  }

  window_size = "PT5M"
  frequency   = "PT1M"
  severity    = 2
  enabled     = true

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
