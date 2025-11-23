provider "azurerm" {
  skip_provider_registration = true

  features {} # enables modern azure api endpoints
  # tells open how to authenticate 
  # (defaults to using credentials from 'az login')
}

provider "databricks" {
  host = azurerm_databricks_workspace.main.workspace_url
}
