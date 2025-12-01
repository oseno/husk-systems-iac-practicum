# modules/sql_server/main.tf
# SQL Server and Database infrastructure module

# ==========================================
# SQL SERVER
# ==========================================

resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  
  dynamic "azuread_administrator" {
    for_each = var.azuread_admin_login != "" ? [1] : []
    content {
      login_username = var.azuread_admin_login
      object_id      = var.azuread_admin_object_id
    }
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = var.tags
}

# ==========================================
# FIREWALL RULES
# ==========================================

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count            = var.allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "additional" {
  for_each         = var.firewall_rules
  name             = each.key
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}

# ==========================================
# DATABASES
# ==========================================

resource "azurerm_mssql_database" "this" {
  for_each  = var.databases
  
  name      = each.value.name
  server_id = azurerm_mssql_server.this.id
  
  sku_name    = each.value.sku_name
  max_size_gb = each.value.max_size_gb
  
  # Backup retention
  short_term_retention_policy {
    retention_days           = each.value.backup_retention_days
    backup_interval_in_hours = each.value.backup_interval_hours
  }
  
  # Long-term retention
  dynamic "long_term_retention_policy" {
    for_each = each.value.enable_ltr ? [1] : []
    content {
      weekly_retention  = each.value.ltr_weekly_retention
      monthly_retention = each.value.ltr_monthly_retention
      yearly_retention  = each.value.ltr_yearly_retention
      week_of_year      = each.value.ltr_week_of_year
    }
  }
  
  geo_backup_enabled                  = each.value.geo_backup_enabled
  transparent_data_encryption_enabled = each.value.tde_enabled
  zone_redundant                      = each.value.zone_redundant
  
  tags = merge(var.tags, each.value.tags)
}

# ==========================================
# AUDITING
# ==========================================

resource "azurerm_storage_account" "audit" {
  count                    = var.enable_auditing ? 1 : 0
  name                     = var.audit_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  
  tags = var.tags
}

resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  count                                   = var.enable_auditing ? 1 : 0
  server_id                               = azurerm_mssql_server.this.id
  storage_endpoint                        = azurerm_storage_account.audit[0].primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.audit[0].primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = var.audit_retention_days
}

# ==========================================
# THREAT DETECTION
# ==========================================

resource "azurerm_mssql_server_security_alert_policy" "this" {
  count               = var.enable_threat_detection ? 1 : 0
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.this.name
  state               = "Enabled"
  
  email_account_admins = var.threat_detection_email_admins
  email_addresses      = var.threat_detection_email_addresses
  retention_days       = var.threat_detection_retention_days
}

# ==========================================
# FAILOVER GROUP (OPTIONAL)
# ==========================================

resource "azurerm_mssql_server" "secondary" {
  count                        = var.enable_failover ? 1 : 0
  name                         = "${var.sql_server_name}-secondary"
  resource_group_name          = var.resource_group_name
  location                     = var.failover_location
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = merge(var.tags, { Role = "Secondary" })
}

resource "azurerm_mssql_failover_group" "this" {
  count     = var.enable_failover ? 1 : 0
  name      = "${var.sql_server_name}-fog"
  server_id = azurerm_mssql_server.this.id
  
  databases = [for db in azurerm_mssql_database.this : db.id]
  
  partner_server {
    id = azurerm_mssql_server.secondary[0].id
  }
  
  read_write_endpoint_failover_policy {
    mode          = var.failover_mode
    grace_minutes = var.failover_grace_minutes
  }
  
  tags = var.tags
}