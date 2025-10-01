terraform {
  backend "azurerm" {
    # Values are loaded from backend.conf during init
    # DO NOT hardcode values here
  }

  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}