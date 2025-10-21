output "id" {
  description = "The ID of the Stream Analytics job"
  value       = azurerm_stream_analytics_job.this.id
}

output "name" {
  description = "The name of the Stream Analytics job"
  value       = azurerm_stream_analytics_job.this.name
}

output "job_id" {
  description = "The Job ID of the Stream Analytics job"
  value       = azurerm_stream_analytics_job.this.job_id
}