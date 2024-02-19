data "azurerm_client_config" "current" {}

# define the resource group, we are using static because there will only be 1 fleet manager instance
resource "azurerm_resource_group" "fleet_manager_rg" {
  name     = "fleet-manager-rg"
  location = "West Europe"
}

# define your fleet manager resource, static name and location, because again, only 1 instance
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

#resource "azapi_resource" "fleet_member" {
#  type      = "Microsoft.ContainerService/fleets/members@2022-09-02-preview"
#  name      = var.fleet_member_name
#  parent_id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.ContainerService/fleets/%s", data.azurerm_client_config.current.subscription_id, azurerm_resource_group.fleet_manager_rg.name, local.fleet_manager_name)
#
#  body = jsonencode({
#    properties = {
#      clusterResourceId = var.aks_cluster_resource_id
#    }
#  })
#}

## They released the resources for fleet member and group add

# add a member to the fleet via this resource definition, most of the values are passed in in the workspace that calls this module when bootstrapping a kubernetes cluster
resource "azurerm_kubernetes_fleet_member" "fleet_member" {
  kubernetes_cluster_id = var.aks_cluster_resource_id   # pass in the cluster_id outputted in the module via variable "id"
  kubernetes_fleet_id   = azurerm_kubernetes_fleet_manager.fleet_manager.id # link to fleet created in this module
  name                  = var.fleet_member_name
  group                 = var.fleet_member_group
}

# Adding update strategy, static name because we currently only use 1 update strategy
resource "azurerm_kubernetes_fleet_update_strategy" "update_strategy" {
  name                      = "default-update-strategy"
  kubernetes_fleet_manager_id = azurerm_kubernetes_fleet_manager.fleet_manager.id

  stage {
    name = "integration-stage"

    after_stage_wait_in_seconds = 600000

    group {
      name = "int"
    }
  }

  stage {
    name = "acceptance-stage"

    after_stage_wait_in_seconds = 120000

    group {
      name = "acc"
    }
  }

  stage {
  name = "production-stage"

  after_stage_wait_in_seconds = 120000

  group {
    name = "prd"
  }
}

  timeouts {
    create = "30m"
    read   = "5m"
    update = "30m"
    delete = "30m"
  }
}