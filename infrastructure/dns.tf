resource "azurerm_private_dns_zone" "aks_private_zone" {
  name                      = "privatelink.${local.location}.azmk8s.io"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_private_zone" {
  name                      = "${azurerm_virtual_network.this.name}-aks-link"
  private_dns_zone_name     = azurerm_private_dns_zone.aks_private_zone.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "privatelink_azurecr_io" {
  name                      = "privatelink.azurecr.io"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_azurecr_io" {
  name                  = "${azurerm_virtual_network.this.name}-acr-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_azurecr_io.name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "privatelink_documents_azure_com" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_documents_azure_com" {
  name                  = "${azurerm_virtual_network.this.name}-cosmos-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_documents_azure_com.name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "privatelink_servicebus_windows_net" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_servicebus_windows_net" {
  name                  = "${azurerm_virtual_network.this.name}-eventhub-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_servicebus_windows_net.name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "privatelink_vaultcore_azure_net" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_vaultcore_windows_net" {
  name                  = "${azurerm_virtual_network.this.name}-keyvault-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "local_developer_zone" {
  name                = "${local.resource_name}.local"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "local_developer_zone" {
  name                  = "${azurerm_virtual_network.this.name}-local-link"
  private_dns_zone_name = azurerm_private_dns_zone.local_developer_zone.name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}