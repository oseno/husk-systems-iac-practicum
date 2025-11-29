# App Service Plan - defines the compute resources
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.tags
}

# App Service - the web application
resource "azurerm_linux_app_service" "main" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_service_plan.main.id

  site_config {
    always_on        = var.always_on
    linux_fx_version = var.runtime_stack
    
    # Enable HTTPS only
    min_tls_version = "1.2"
    ftps_state      = "FtpsOnly"
  }

  app_settings = var.app_settings

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_windows_app_service" "main" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_service_plan.main.id

  site_config {
    always_on       = var.always_on
    dotnet_framework_version = var.runtime_stack
    
    min_tls_version = "1.2"
    ftps_state      = "FtpsOnly"
  }

  app_settings = var.app_settings

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Autoscaling settings
resource "azurerm_monitor_autoscale_setting" "main" {
  count               = var.enable_autoscale ? 1 : 0
  name                = "autoscale-${var.app_service_plan_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_service_plan.main.id

  profile {
    name = "default"

    capacity {
      default = var.autoscale_default_instances
      minimum = var.autoscale_min_instances
      maximum = var.autoscale_max_instances
    }

    # Scale out rule - add instances when CPU > 70%
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # Scale in rule - remove instances when CPU < 30%
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # Scale out rule - add instances when Memory > 75%
    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = azurerm_service_plan.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  tags = var.tags
}

# VNet Integration (optional)
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  count          = var.enable_vnet_integration && var.os_type == "Linux" ? 1 : 0
  app_service_id = azurerm_linux_app_service.main[0].id
  subnet_id      = var.subnet_id
}