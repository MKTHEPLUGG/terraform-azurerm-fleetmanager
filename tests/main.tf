module "fleet_manager" {
  source = "./../"  # Update this path to where your module is located

  fleet_name             = module.fleet_manager.fleet_manager_name
  fleet_member_name      = module.aks.name
  aks_cluster_resource_id = module.aks.id  # "/subscriptions/.../resourceGroups/.../providers/Microsoft.ContainerService/managedClusters/my-aks-cluster"
  resource_group    = module.resource_group.name
  environment = "development"
  project_name = "fleet-manager"
}