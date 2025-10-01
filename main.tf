# Local values for computed/derived values
locals {
  # Generate unique storage account name using timestamp
  test_storage_name = "${var.test_storage_name_prefix}${formatdate("MMDD", timestamp())}"
  
  # Common tags applied to all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner
    ManagedBy   = "OpenTofu"
    Client      = "Husk Power Systems"
  }
}

# Test storage account
resource "azurerm_storage_account" "test" {
  name                     = local.test_storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      name  # Ignore name changes since we use timestamp
    ]
  }
}