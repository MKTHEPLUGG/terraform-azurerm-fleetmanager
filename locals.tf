locals {
  fleet_manager_name                             = "ms-${local.environment_short[var.environment]}-akf-${var.project_name}-${local.location_short[azurerm_kubernetes_fleet_manager.fleet_manager.location]}-${var.sequence_number}"
  location_short                           = {
    westeurope  = "we"
    northeurope = "ne"
  }
  environment_short = {
    production    = "prd"
    hub           = "hub"
    nonproduction = "nonprd"
    acceptance    = "acc"
    integration   = "int"
    development   = "dev"
  }
}