resource "azurerm_stream_analytics_job" "this" {
  name                                     = var.name
  resource_group_name                      = var.resource_group_name
  location                                 = var.location
  compatibility_level                      = "1.2"
  data_locale                             = "en-US"
  events_late_arrival_max_delay_in_seconds = 60
  events_out_of_order_max_delay_in_seconds = 50
  events_out_of_order_policy              = "Adjust"
  output_error_policy                     = "Drop"
  streaming_units                         = var.streaming_units
  transformation_query                    = var.transformation_query

  tags = var.tags
}