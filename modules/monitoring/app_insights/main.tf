resource "azurerm_application_insights" "this" {
  name                = var.ai_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.log_analytics_workspace.id
  tags                = var.tags
}
