resource "azurerm_storage_account" "main" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true

  tags = var.tags
}

resource "azurerm_storage_container" "filesystem" {
  name                  = var.filesystem_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Lifecycle Management Policy for automatic data tiering
resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.main.id

  # Rule 1: Move to Cool tier after 30 days
  rule {
    name    = "tier-to-cool"
    enabled = true
    
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = []  # Apply to all blobs
    }
    
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
      }
    }
  }

  # Rule 2: Move to Archive tier after 90 days
  rule {
    name    = "tier-to-archive"
    enabled = true
    
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = []
    }
    
    actions {
      base_blob {
        tier_to_archive_after_days_since_modification_greater_than = 90
      }
    }
  }

  # Rule 3: Delete old data after 1 year
  rule {
    name    = "delete-old-data"
    enabled = true
    
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = []
    }
    
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 365
      }
    }
  }

  # Rule 4: Clean up snapshots after 30 days
  rule {
    name    = "delete-snapshots"
    enabled = true
    
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = []
    }
    
    actions {
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }
}