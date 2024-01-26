terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">=3.0.0,<4.0.0"
      configuration_aliases = [azurerm.mgmt]
    }
    azapi = {
      source = "Azure/azapi"
      version = ">=1.0.0,<2.0.0"
      configuration_aliases = [azurerm.mgmt]
    }
  }
}