output "fleet_manager_id" {
  value = azurerm_kubernetes_fleet_manager.fleet_manager.id
  description = "The ID of the Fleet Manager"
}

output "fleet_manager_name" {
  value = azurerm_kubernetes_fleet_manager.fleet_manager.name
  description = "The name of the Fleet Manager"
}