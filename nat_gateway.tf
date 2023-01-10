resource "azurerm_public_ip_prefix" "nat_prefix" {
  name                = "${var.aks_cluster_name}-pipp"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  ip_version          = "IPv4"
  prefix_length       = 29
  sku                 = "Standard"
  zones               = ["1"]
}
resource "azurerm_nat_gateway" "nat_gw" {
  name                    = "${var.aks_cluster_name}-natgw"
  resource_group_name     = azurerm_resource_group.resource_group.name
  location                = azurerm_resource_group.resource_group.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_ips" {
  nat_gateway_id      = azurerm_nat_gateway.nat_gw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat_prefix.id

}

resource "azurerm_subnet_nat_gateway_association" "sn_cluster_nat_gw" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

output "gateway_ip_prefix" {
  value = azurerm_public_ip_prefix.nat_prefix.ip_prefix
}