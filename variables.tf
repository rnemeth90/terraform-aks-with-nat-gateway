variable "location" {
 type    = string
 default   = "eastus"
 description = "The region where the resources will be created."
}

variable "aks_cluster_name" {
 type    = string
 description = "The name assigned to the cluster."
}

variable "vnet" {
 type = object({
  cird      = string
  sn_cluster_cird = string
 })
 default = {
  cird      = "10.1.0.0/16"
  sn_cluster_cird = "10.1.0.0/22"
 }
 description = "The VNET and subnet configuration."
}
