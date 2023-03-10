variable "location" {
  type        = string
  default     = "eastus"
  description = "The region where the resources will be created."
}

variable "aks_cluster_name" {
  type        = string
  default     = "az-rtn-aks-natgw-01"
  description = "The name assigned to the cluster."
}

variable "vnet" {
  type = object({
    cidr            = string
    sn_cluster_cidr = string
  })
  default = {
    cidr            = "10.1.0.0/16"
    sn_cluster_cidr = "10.1.0.0/22"
  }
  description = "The VNET and subnet configuration."
}
