terraform {
  backend "azurerm" {
    # Backend configuration will be loaded from backend.conf
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy       = true
      recover_soft_deleted_key_vaults   = true
    }
  }

  # No subscription_id here; will use:
  # 1. ARM_SUBSCRIPTION_ID env var (GitHub Actions)
  # 2. Azure CLI login (local dev)
}

provider "databricks" {
  # Databricks provider will be configured after workspace creation
}
