# stream-analytics.tf
# Fully parameterized Stream Analytics configuration

# ==========================================
# LOCALS FOR DYNAMIC CONFIGURATION
# ==========================================

locals {
  # Generate transformation query from template
  transformation_query = templatefile("${path.module}/queries/transformation.sql.tpl", {
    window_type          = var.transformation_window_type
    window_duration      = var.transformation_window_duration
    hop_size             = var.transformation_hop_size
    aggregate_functions  = var.transformation_aggregate_functions
    filter_condition     = var.transformation_filter_condition
    group_by_fields      = var.transformation_group_by_fields
    partition_by         = var.transformation_partition_by
  })
  
  # Conditional resource creation
  create_blob_output = var.output_type == "blob"
  create_sql_output  = var.output_type == "sql" && var.output_sql_server != ""
  
  # Stream Analytics tags
  stream_tags = merge(
    local.common_tags,
    {
      Purpose = "Real-time Analytics"
      Sprint  = "Sprint-2"
    }
  )
}

# ==========================================
# EVENT HUB RESOURCES
# ==========================================

resource "azurerm_eventhub_namespace" "main" {
  name                = var.eventhub_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1

  tags = local.stream_tags
}

resource "azurerm_eventhub" "main" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = var.eventhub_partition_count
  message_retention   = var.eventhub_message_retention
}

resource "azurerm_eventhub_authorization_rule" "stream_analytics" {
  name                = "StreamAnalyticsAccess"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.main.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

# ==========================================
# STREAM ANALYTICS JOB
# ==========================================

resource "azurerm_stream_analytics_job" "main" {
  name                = var.stream_analytics_job_name
  resource_group_name = var.resource_group_name
  location            = var.location
  
  streaming_units     = var.streaming_units
  compatibility_level = var.compatibility_level
  
  # Parameterized event ordering
  events_out_of_order_policy                = "Adjust"
  events_out_of_order_max_delay_in_seconds  = var.transformation_out_of_order_tolerance
  events_late_arrival_max_delay_in_seconds  = var.transformation_late_arrival_tolerance
  output_error_policy                       = var.transformation_output_error_policy
  
  # Dynamic transformation query
  transformation_query = local.transformation_query
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = local.stream_tags
}

# ==========================================
# INPUT: EVENT HUB
# ==========================================

resource "azurerm_stream_analytics_stream_input_eventhub" "input" {
  name                         = "EventHubInput"
  stream_analytics_job_name    = azurerm_stream_analytics_job.main.name
  resource_group_name          = var.resource_group_name
  
  eventhub_consumer_group_name = var.input_consumer_group
  eventhub_name                = azurerm_eventhub.main.name
  servicebus_namespace         = azurerm_eventhub_namespace.main.name
  
  shared_access_policy_key     = azurerm_eventhub_authorization_rule.stream_analytics.primary_key
  shared_access_policy_name    = azurerm_eventhub_authorization_rule.stream_analytics.name
  
  serialization {
    type     = var.input_serialization_type
    encoding = var.input_serialization_encoding
  }
}

# ==========================================
# OUTPUT: BLOB STORAGE
# ==========================================

# Storage container for output
resource "azurerm_storage_container" "stream_output" {
  name                  = var.output_blob_container
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

# Blob output
resource "azurerm_stream_analytics_output_blob" "output" {
  count = local.create_blob_output ? 1 : 0
  
  name                      = "BlobOutput"
  stream_analytics_job_name = azurerm_stream_analytics_job.main.name
  resource_group_name       = var.resource_group_name
  
  storage_account_name   = azurerm_storage_account.test.name
  storage_account_key    = azurerm_storage_account.test.primary_access_key
  storage_container_name = azurerm_storage_container.stream_output.name
  path_pattern           = var.output_blob_path_pattern
  date_format            = var.output_blob_date_format
  time_format            = var.output_blob_time_format
  batch_max_wait_time    = "00:01:00"
  batch_min_rows         = var.output_batch_size
  
  serialization {
    type     = var.output_serialization_type
    encoding = "UTF8"
    format   = var.output_serialization_format
  }
}

# ==========================================
# OUTPUT: SQL DATABASE (OPTIONAL)
# ==========================================

resource "azurerm_stream_analytics_output_mssql" "output" {
  count = local.create_sql_output ? 1 : 0
  
  name                      = "SqlOutput"
  stream_analytics_job_name = azurerm_stream_analytics_job.main.name
  resource_group_name       = var.resource_group_name
  
  server   = var.output_sql_server
  database = var.output_sql_database
  table    = var.output_sql_table
  user     = var.output_sql_user
  password = var.output_sql_password
  
  max_batch_count  = var.output_batch_size
  max_writer_count = 1
}

# ==========================================
# AUTO-START (OPTIONAL)
# ==========================================

resource "null_resource" "start_stream_analytics_job" {
  count = var.auto_start_stream_job ? 1 : 0
  
  depends_on = [
    azurerm_stream_analytics_job.main,
    azurerm_stream_analytics_stream_input_eventhub.input,
    azurerm_stream_analytics_output_blob.output
  ]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Starting Stream Analytics job..."
      az stream-analytics job start \
        --name ${azurerm_stream_analytics_job.main.name} \
        --resource-group ${var.resource_group_name} \
        --output-start-mode ${var.job_start_mode}
      echo "Stream Analytics job start command executed"
    EOT
  }
  
  triggers = {
    query_hash = md5(local.transformation_query)
    config_hash = md5(jsonencode({
      streaming_units = var.streaming_units
      window_type     = var.transformation_window_type
      window_duration = var.transformation_window_duration
    }))
  }
}

# ==========================================
# MONITORING RESOURCES
# ==========================================

resource "azurerm_log_analytics_workspace" "stream_analytics" {
  count = var.enable_diagnostics ? 1 : 0
  
  name                = "log-${var.stream_analytics_job_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  
  tags = local.stream_tags
}

resource "azurerm_monitor_diagnostic_setting" "stream_analytics" {
  count = var.enable_diagnostics ? 1 : 0
  
  name                       = "diag-${var.stream_analytics_job_name}"
  target_resource_id         = azurerm_stream_analytics_job.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.stream_analytics[0].id
  
  enabled_log {
    category = "Execution"
  }
  
  enabled_log {
    category = "Authoring"
  }
  
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_metric_alert" "stream_job_errors" {
  count = var.enable_metric_alerts ? 1 : 0
  
  name                = "alert-${var.stream_analytics_job_name}-errors"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_stream_analytics_job.main.id]
  description         = "Alert when Stream Analytics job has errors"
  severity            = var.alert_severity
  frequency           = "PT1M"
  window_size         = "PT5M"
  
  criteria {
    metric_namespace = "Microsoft.StreamAnalytics/streamingjobs"
    metric_name      = "Errors"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.error_alert_threshold
  }
  
  tags = local.stream_tags
}