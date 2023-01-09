resource "azurerm_resource_group" "resource_group" {
 name   = "${var.aks_cluster_name}-rg"
 location = var.location
}
