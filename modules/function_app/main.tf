# Storage Account for Function App (required)
resource "azurerm_storage_account" "function" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# App Service Plan for Function App
resource "azurerm_service_plan" "function" {
  name                = var.function_app_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.tags
}

# Linux Function App
resource "azurerm_linux_function_app" "main" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.function.id

  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  site_config {
    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_key

    application_stack {
      python_version = var.runtime == "python" ? var.runtime_version : null
      node_version   = var.runtime == "node" ? var.runtime_version : null
      dotnet_version = var.runtime == "dotnet" ? var.runtime_version : null
      java_version   = var.runtime == "java" ? var.runtime_version : null
    }

    minimum_tls_version = "1.2"
  }

  app_settings = merge(
    var.app_settings,
    {
      "FUNCTIONS_WORKER_RUNTIME" = var.runtime
    }
  )

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Windows Function App
resource "azurerm_windows_function_app" "main" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.function.id

  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  site_config {
    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_key

    application_stack {
      dotnet_version              = var.runtime == "dotnet" ? var.runtime_version : null
      node_version                = var.runtime == "node" ? var.runtime_version : null
      java_version                = var.runtime == "java" ? var.runtime_version : null
      powershell_core_version     = var.runtime == "powershell" ? var.runtime_version : null
    }

    minimum_tls_version = "1.2"
  }

  app_settings = merge(
    var.app_settings,
    {
      "FUNCTIONS_WORKER_RUNTIME" = var.runtime
    }
  )

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Autoscaling settings (only for non-Consumption plans)
resource "azurerm_monitor_autoscale_setting" "function" {
  count               = var.enable_autoscale && var.sku_name != "Y1" ? 1 : 0
  name                = "autoscale-${var.function_app_plan_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_service_plan.function.id

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
        metric_resource_id = azurerm_service_plan.function.id
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
        metric_resource_id = azurerm_service_plan.function.id
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
  }

  tags = var.tags
}

# VNet Integration (optional)
resource "azurerm_app_service_virtual_network_swift_connection" "function" {
  count          = var.enable_vnet_integration && var.os_type == "Linux" ? 1 : 0
  app_service_id = azurerm_linux_function_app.main[0].id
  subnet_id      = var.subnet_id
}