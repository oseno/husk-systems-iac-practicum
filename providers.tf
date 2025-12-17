terraform {
  backend "azurerm" {
    # Backend configuration will be loaded from backend.conf
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}


provider "databricks" {
  # Databricks provider will be configured after workspace creation
}
