provider "databricks" {
  host = azurerm_databricks_workspace.main.workspace_url
}
