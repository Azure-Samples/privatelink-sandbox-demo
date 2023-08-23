resource "azurerm_cosmosdb_account" "this" {

  count = var.deploy_cosmosdb == true ? 1 : 0

  name                            = local.cosmosdb_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  offer_type                      = "Standard"
  kind                            = "GlobalDocumentDB"
  enable_multiple_write_locations = true
  enable_automatic_failover       = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.this.location
    failover_priority = 0
  }
}

resource "azurerm_private_endpoint" "cosmos_db" {

  count = var.deploy_cosmosdb == true ? 1 : 0

  name                = "${local.cosmosdb_name}-endpoint"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "${local.cosmosdb_name}-endpoint"
    private_connection_resource_id = azurerm_cosmosdb_account.this[0].id
    subresource_names              = ["sql"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.privatelink_documents_azure_com.name
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_documents_azure_com.id]
  }
}