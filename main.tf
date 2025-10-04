# Commented out to test resource group in isolation
# # Local values for computed/derived values
# locals {
#   # Generate unique storage account name using timestamp
#   test_storage_name = "${var.test_storage_name_prefix}${formatdate("MMDD", timestamp())}"

#   # Common tags applied to all resources
#   common_tags = {
#     Environment = var.environment
#     Project     = var.project_name
#     Owner       = var.owner
#     ManagedBy   = "OpenTofu"
#     Purpose     = "Testing OpenTofu setup"
#   }
# }

# # Test storage account
# resource "azurerm_storage_account" "test" {
#   name                     = local.test_storage_name
#   resource_group_name      = var.resource_group_name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = local.common_tags

#   lifecycle {
#     ignore_changes = [
#       name # Ignore name changes since we use timestamp
#     ]
#   }
# }

module "resource_group" {
  source = "./modules/resource_group"

  name     = "${var.environment}-${var.project_name}-rg"
  location = var.location
  tags     = var.tags
}

module "storage_account" {
  source = "./modules/storage_account"

  name                = "${var.environment}-${var.project_name}-sa-${random_string.suffix.result}" # unique storage account name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  filesystem_name     = "${var.project_name}-${var.environment}-fs"
  tags                = module.resource_group.tags
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}
