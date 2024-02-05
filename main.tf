data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "fleet_manager_rg" {
  name     = "fleet-manager-rg"
  location = "West Europe"
}

resource "azurerm_kubernetes_fleet_manager" "fleet_manager" {
  name                = local.fleet_manager_name
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.fleet_manager_rg.name

  # Configuration properties for Fleet Manager
  hub_profile {
    dns_prefix = "aks-dev-we-mvh" # Ensure this DNS prefix is unique within the Azure region
  }
}

# Logic to associate AKS clusters with Fleet Manager
# doesn't exist yet? using preview via azapi

resource "azapi_resource" "fleet_member" {
  type      = "Microsoft.ContainerService/fleets/members@2022-09-02-preview"
  name      = var.fleet_member_name
  parent_id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.ContainerService/fleets/%s", data.azurerm_client_config.current.subscription_id, azurerm_resource_group.fleet_manager_rg.name, local.fleet_manager_name)

  body = jsonencode({
    properties = {
      clusterResourceId = var.aks_cluster_resource_id
    }
  })
}

# Adding update strategy
resource "azurerm_kubernetes_fleet_update_strategy" "example_update_strategy" {
  name                      = "default-update-strategy"
  kubernetes_fleet_manager_id = azurerm_kubernetes_fleet_manager.fleet_manager.id

  stage {
    name = "integration-stage"

    after_stage_wait_in_seconds = 60

    group {
      name = "integration-group"
    }
  }

  stage {
    name = "acceptance-stage"

    after_stage_wait_in_seconds = 120

    group {
      name = "acceptance-group"
    }
  }

  timeouts {
    create = "30m"
    read   = "5m"
    update = "30m"
    delete = "30m"
  }
}
