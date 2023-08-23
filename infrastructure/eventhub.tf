
resource "azurerm_eventhub_namespace" "this" {

  count = var.deploy_eventhub == true ? 1 : 0

  name                     = local.eventhub_namespace_name
  location                 = azurerm_resource_group.this.location
  resource_group_name      = azurerm_resource_group.this.name
  sku                      = "Standard"
  maximum_throughput_units = 5
  auto_inflate_enabled     = true
}

resource "azurerm_eventhub" "this" {

  count = var.deploy_eventhub == true ? 1 : 0

  name                = "samples"
  namespace_name      = azurerm_eventhub_namespace.this[0].name
  resource_group_name = azurerm_resource_group.this.name
  partition_count     = 15
  message_retention   = 7
}

resource "azurerm_private_endpoint" "eventhub_namespace" {

  count = var.deploy_eventhub == true ? 1 : 0

  name                = "${local.eventhub_namespace_name}-endpoint"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "${local.eventhub_namespace_name}-endpoint"
    private_connection_resource_id = azurerm_eventhub_namespace.this[0].id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.privatelink_servicebus_windows_net.name
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_servicebus_windows_net.id]
  }
}
