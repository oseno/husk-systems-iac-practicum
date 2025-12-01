# modules/sql_server/variables.tf

# ==========================================
# REQUIRED VARIABLES
# ==========================================

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sql_admin_login" {
  description = "SQL Server administrator login"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

# ==========================================
# SERVER CONFIGURATION
# ==========================================

variable "sql_server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "azuread_admin_login" {
  description = "Azure AD admin login"
  type        = string
  default     = ""
}

variable "azuread_admin_object_id" {
  description = "Azure AD admin object ID"
  type        = string
  default     = ""
}

# ==========================================
# FIREWALL RULES
# ==========================================

variable "allow_azure_services" {
  description = "Allow Azure services to access server"
  type        = bool
  default     = true
}

variable "firewall_rules" {
  description = "Map of firewall rules"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

# ==========================================
# DATABASES
# ==========================================

variable "databases" {
  description = "Map of databases to create"
  type = map(object({
    name                     = string
    sku_name                 = string
    max_size_gb              = number
    backup_retention_days    = number
    backup_interval_hours    = number
    enable_ltr               = bool
    ltr_weekly_retention     = string
    ltr_monthly_retention    = string
    ltr_yearly_retention     = string
    ltr_week_of_year         = number
    geo_backup_enabled       = bool
    tde_enabled              = bool
    zone_redundant           = bool
    tags                     = map(string)
  }))
}

# ==========================================
# AUDITING
# ==========================================

variable "enable_auditing" {
  description = "Enable auditing"
  type        = bool
  default     = true
}

variable "audit_storage_account_name" {
  description = "Storage account for audit logs"
  type        = string
  default     = ""
}

variable "audit_retention_days" {
  description = "Audit log retention days"
  type        = number
  default     = 90
}

# ==========================================
# THREAT DETECTION
# ==========================================

variable "enable_threat_detection" {
  description = "Enable threat detection"
  type        = bool
  default     = true
}

variable "threat_detection_email_admins" {
  description = "Email account admins on threats"
  type        = bool
  default     = true
}

variable "threat_detection_email_addresses" {
  description = "Email addresses for threat alerts"
  type        = list(string)
  default     = []
}

variable "threat_detection_retention_days" {
  description = "Threat detection log retention"
  type        = number
  default     = 30
}

# ==========================================
# FAILOVER
# ==========================================

variable "enable_failover" {
  description = "Enable failover group"
  type        = bool
  default     = false
}

variable "failover_location" {
  description = "Secondary region for failover"
  type        = string
  default     = "West US"
}

variable "failover_mode" {
  description = "Failover mode (Automatic or Manual)"
  type        = string
  default     = "Automatic"
}

variable "failover_grace_minutes" {
  description = "Grace period for automatic failover"
  type        = number
  default     = 60
}

# ==========================================
# TAGS
# ==========================================

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}