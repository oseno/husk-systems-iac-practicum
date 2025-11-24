resource "azurerm_dashboard" "team" {
  name                = "${var.prefix}-dashboard-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  dashboard_properties = jsonencode({
    "$schema" = "https://schema.management.azure.com/schemas/2019-04-01/dashboard.json"
    "lenses" = {
      "0" = {
        "order" = 0
        "parts" = {
          "cpuPart" = {
            "position" = { "x" = 0, "y" = 0, "colSpan" = 6, "rowSpan" = 4 }
            "metadata" = {
              "inputs" = [
                {
                  "name"  = "resourceId"
                  "value" = "${var.app_service_id}"
                }
              ]
              "type" = "Extension/HubsExtension/PartType/ChartPart"
              "settings" = {
                "chartType"       = "LineChart"
                "aggregation"     = "Average"
                "metricNamespace" = "Microsoft.Web/sites"
                "metricName"      = "CpuPercentage"
                "title"           = "App Service CPU %"
                "yAxis"           = { "min" = 0, "max" = 100 }
              }
            }
          },

          "funcRequests" = {
            "position" = { "x" = 6, "y" = 0, "colSpan" = 6, "rowSpan" = 4 }
            "metadata" = {
              "inputs" = [
                { "name" = "resourceId", "value" = "${var.function_app_id}" }
              ]
              "type" = "Extension/HubsExtension/PartType/ChartPart"
              "settings" = {
                "chartType"       = "LineChart"
                "metricNamespace" = "Microsoft.Web/sites"
                "metricName"      = "FunctionExecutionCount"
                "title"           = "Function Executions"
                "aggregation"     = "Total"
              }
            }
          },

          #  from log analytics
          "aiErrors" = {
            "position" = { "x" = 0, "y" = 4, "colSpan" = 12, "rowSpan" = 4 }
            "metadata" = {
              "type" = "Extension/HubsExtension/PartType/LogAnalyticsPart"
              "inputs" = [
                {
                  "name"  = "resourceId"
                  "value" = "${var.log_analytics_workspace_id}"
                },
                {
                  "name"  = "query"
                  "value" = "traces | where severityLevel >= 3 | summarize Count=count() by bin(timestamp, 5m) | order by timestamp desc"
                }
              ]
              "settings" = { "title" = "AppInsights Errors(5 min)" }
            }
          },

          "budgetTile" = {
            "position" = { "x" = 0, "y" = 8, "colSpan" = 12, "rowSpan" = 2 }
            "metadata" = {
              "type" = "Extension/HubsExtension/PartType/MarkdownPart"
              "settings" = {
                "content" = "## Cost Overview\n> Budget: **${var.budget_amount} USD**\n> Current Spend: **${var.current_spend}**\n> Remaining: **${var.budget_amount - var.current_spend} USD**"
              }
            }
          }
        }
      }
    }

    "metadata" = { "model" = "dashboard" }
  })
}
