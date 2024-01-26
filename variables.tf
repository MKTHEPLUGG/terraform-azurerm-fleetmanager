variable "resource_group" {
  description = "The resource group"
  type = object({
    id       = string
    name     = string
    location = string
    tags     = map(string)
  })
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "fleet_member_name" {
  description = "The name for the fleet member."
  type        = string
}

variable "aks_cluster_resource_id" {
  description = "The ARM resource ID of the AKS cluster."
  type        = list(string)
}