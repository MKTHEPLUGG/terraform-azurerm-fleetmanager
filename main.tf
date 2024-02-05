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
}

# Logic to associate AKS clusters with Fleet Manager
# This will depend on the specific Azure resources and properties needed for integration
# doesn't exist yet? using preview via azapi

resource "azapi_resource" "fleet_member" {
  type      = "Microsoft.ContainerService/fleets/members@2022-09-02-preview"
  name      = var.fleet_member_name
  parent_id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.ContainerService/fleets/%s", var.aks_resource_group_name, azurerm_resource_group.fleet_manager_rg.name, local.fleet_manager_name)

  body = jsonencode({
    properties = {
      clusterResourceId = var.aks_cluster_resource_id
    }
  })
}
