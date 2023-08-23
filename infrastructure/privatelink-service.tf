data "azurerm_lb" "aks_ingress_lb" {
    depends_on = [ 
      azurerm_kubernetes_flux_configuration.flux_config
     ]
    name                = "kubernetes-internal"
    resource_group_name = "${local.resource_name}_k8s_nodes_rg"
}

resource "azurerm_private_link_service" "this" {

  count = var.deploy_private_link_service == true ? 1 : 0

  name                                        = "${local.aks_name}-privatelink-service"
  resource_group_name                         = azurerm_resource_group.this.name
  location                                    = azurerm_resource_group.this.location
  enable_proxy_protocol                       = false
  auto_approval_subscription_ids              = [var.core_subscription]
  visibility_subscription_ids                 = [var.core_subscription]
  load_balancer_frontend_ip_configuration_ids = [data.azurerm_lb.aks_ingress_lb.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name                       = "primary"
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.privatelink-snat.id
    primary                    = true
  }
}
 
resource "azurerm_private_endpoint" "aks_ingress_core" {

  count = var.deploy_private_link_service == true ? 1 : 0

  name                = "${local.aks_name}-ingress-core-endpoint"
  resource_group_name = var.core_private_endpoint_rg_name
  location            = azurerm_resource_group.this.location
  subnet_id           = data.azurerm_subnet.core_private-endpoints.id
  provider            = azurerm.core
  
  private_service_connection {
    name                           ="${local.aks_name}-ingress-core-endpoint"
    private_connection_resource_id = azurerm_private_link_service.this[0].id
    is_manual_connection           = false
  }

}