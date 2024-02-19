#variable "aks_resource_group_name" {
#  description = "The resource group of the aks cluster"
#  type = string
#}

#variable "environment" {
#  type = string
#}
#
#variable "project_name" {
#  type = string
#}

variable "fleet_member_name" {
  description = "The name for the fleet member."
  type        = string
}

variable "fleet_member_group" {
  description = "The update group the fleet member should be a member of."
  type        = string
}

variable "aks_cluster_resource_id" {
  description = "The ARM resource ID of the AKS cluster."
  type        = string
}