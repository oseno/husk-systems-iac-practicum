data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name # assuming the key vault are in the same RG as the other resources
}

resource "azurerm_key_vault_access_policy" "databricks_access" {
  key_vault_id = data.azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_key_vault.key_vault.tenant_id
  object_id = azurerm_databricks_workspace.main.storage_account_identity[0].object_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_databricks_workspace" "main" {
  name                        = var.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku_name
  managed_resource_group_name = "${var.resource_group_name}-db-managed"

  tags = var.tags
}

resource "databricks_cluster" "job_cluster" {
  cluster_name            = "job-cluster-${var.environment}"
  spark_version           = var.spark_version
  node_type_id            = "Standard_D4ds_v4"
  autotermination_minutes = 30

  autoscale {
    min_workers = var.autoscale_min_workers_value
    max_workers = var.autoscale_max_max_workers_value
  }

  policy_id = databricks_cluster_policy.optimized_autoscaling.id

  library {
    pypi {
      package = "pandas>=1.5.0"
    }
  }

  library {
    pypi {
      package = "numpy"
    }
  }
}

resource "databricks_secret_scope" "keyvault_backed" {
  name         = var.key_vault_secret_scope_name
  backend_type = "AZURE_KEYVAULT"

  keyvault_metadata {
    resource_id = data.azurerm_key_vault.key_vault.id
    dns_name    = data.azurerm_key_vault.key_vault.vault_uri
  }

  initial_manage_principal = "users"
}

resource "databricks_cluster_policy" "optimized_autoscaling" {
  name        = "Optimized-autoscaling-policy-${var.environment}"
  description = "Enforces autoscaling and auto-termination and limits costly instance types"

  definition = jsonencode({
    "autoscale.policy_enabled" : {
      "name" : "fixed",
      "value" : var.autoscale_policy_enabled_value
    },
    "autoscale.min_workers" : {
      "type" : "fixed",
      "value" : var.autoscale_min_workers_value
    },
    "autoscale.max_workers" : {
      "type" : "range",
      "maxValue" : var.autoscale_max_max_workers_value,
      "minValue" : var.autoscale_max_min_workers_value
    },
    "node_type_id" : {
      "type" : "allowlist",
      "values" : var.allowed_node_types,
      "default_value" : "Standard_D4ds_v4"
    },
    "autotermination_minutes" : {
      "type" : "range",
      "maxValue" : var.autotermination_minutes_maxValue,
      "minValue" : var.autotermination_minutes_minValue,
      "defaultValue" : 30
    }
  })
}

resource "databricks_group" "data_engineers" {
  display_name = "Data Engineers - ${var.environment}"
}

resource "databricks_cluster_policy_attachment" "engineers_policy_attach" {
  cluster_policy_id = databricks_cluster_policy.optimized_autoscaling.id
  group_id          = databricks_group.data_engineers.id
}

resource "databricks_permissions" "data_engineers_access" {

  access_control {
    group_name       = databricks_group.data_engineers.display_name
    permission_level = "CAN_USE"
  }

  cluster_policy_id = databricks_cluster_policy.optimized_autoscaling.id

}


