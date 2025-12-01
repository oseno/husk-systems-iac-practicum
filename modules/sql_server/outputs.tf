# modules/sql_server/outputs.tf

output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "sql_server_identity_principal_id" {
  description = "Principal ID of SQL Server managed identity"
  value       = azurerm_mssql_server.this.identity[0].principal_id
}

output "databases" {
  description = "Map of created databases"
  value = {
    for key, db in azurerm_mssql_database.this : key => {
      id       = db.id
      name     = db.name
      sku_name = db.sku_name
    }
  }
}

output "failover_group_id" {
  description = "ID of failover group (if enabled)"
  value       = var.enable_failover ? azurerm_mssql_failover_group.this[0].id : null
}

output "secondary_server_fqdn" {
  description = "FQDN of secondary server (if failover enabled)"
  value       = var.enable_failover ? azurerm_mssql_server.secondary[0].fully_qualified_domain_name : null
}

output "audit_storage_account_id" {
  description = "ID of audit storage account (if enabled)"
  value       = var.enable_auditing ? azurerm_storage_account.audit[0].id : null
}