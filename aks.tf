data "azurerm_kubernetes_service_versions" "aks_version" {
  location        = azurerm_resource_group.resource_group.location
  include_preview = false
}

resource "random_string" "random_str" {
  length  = 4
  lower   = true
  special = false
  upper   = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.aks_cluster_name}-aks"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  node_resource_group = "${var.aks_cluster_name}-np-rg"
  sku_tier            = "Free"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.aks_version.latest_version

  dns_prefix = "${var.aks_cluster_name}-${random_string.random_str.result}"

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_D4s_v4"
    zones               = ["1", "2", "3"]
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    os_disk_type        = "Managed"
    os_disk_size_gb     = 32
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = azurerm_subnet.subnet.id
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "172.16.0.10"
    docker_bridge_cidr = "172.18.0.1/16"
    service_cidr       = "172.16.0.0/16"
    load_balancer_sku  = "standard"
    outbound_type      = "userAssignedNATGateway"
    nat_gateway_profile {
      idle_timeout_in_minutes = 4
    }
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      network_profile[0].nat_gateway_profile
    ]
  }
}
output "dns_name" {
  value = azurerm_kubernetes_cluster.aks.dns_prefix
}
