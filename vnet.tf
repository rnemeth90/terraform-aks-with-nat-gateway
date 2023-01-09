# vnet.tf
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.aks_cluster_name}-vnet"
  address_space       = [var.vnet.cird]
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
}

resource "azurerm_subnet" "cluster" {
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  name                 = var.aks_cluster_name
  virtual_network_name = "${var.aks_cluster_name}-vnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = [var.vnet.sn_cluster_cird]
}
