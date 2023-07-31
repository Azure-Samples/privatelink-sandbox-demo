resource "azurerm_network_security_group" "this" {
  name                = "${local.resource_name}-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "nodes" {
  subnet_id                 = azurerm_subnet.nodes.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "api" {
  subnet_id                 = azurerm_subnet.api.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "privatelink-snat" {
  subnet_id                 = azurerm_subnet.privatelink-snat.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "private-endpoints" {
  subnet_id                 = azurerm_subnet.private-endpoints.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "compute" {
  subnet_id                 = azurerm_subnet.compute.id
  network_security_group_id = azurerm_network_security_group.this.id
}

#https://github.com/libre-devops/terraform-azurerm-bastion/blob/main/nsg.tf
resource "azurerm_network_security_group" "bastion" {
  name                = "${local.resource_name}-bastion-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "bastion_nsg" {
  for_each = var.azure_bastion_nsg_list

  name                   = each.key
  priority               = each.value.priority
  direction              = each.value.direction
  access                 = each.value.access
  protocol               = each.value.protocol
  source_port_range      = each.value.source_port
  destination_port_range = each.value.destination_port
  source_address_prefix  = each.value.source_address_prefix

  #tfsec:ignore:azure-network-no-public-egress
  destination_address_prefix = each.value.destination_address_prefix

  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.bastion.name
}

#tfsec:ignore:azure-network-no-public-egress
variable "azure_bastion_nsg_list" {
  default = {
    "AllowHttpsInbound"                       = { priority = "120", direction = "Inbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "Tcp", source_address_prefix = "Internet", destination_address_prefix = "*" },
    "AllowGatewayManagerInbound"              = { priority = "130", direction = "Inbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "Tcp", source_address_prefix = "GatewayManager", destination_address_prefix = "*" },
    "AllowAzureLoadBalancerInbound"           = { priority = "140", direction = "Inbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "Tcp", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "*" },
    "AllowBastionHostCommunication1"          = { priority = "150", direction = "Inbound", source_port = "*", destination_port = "5701", access = "Allow", protocol = "Tcp", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowBastionHostCommunication2"          = { priority = "155", direction = "Inbound", source_port = "*", destination_port = "80", access = "Allow", protocol = "Tcp", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowSSHRDPOutbound1"                    = { priority = "160", direction = "Outbound", source_port = "*", destination_port = "22", access = "Allow", protocol = "Tcp", source_address_prefix = "*", destination_address_prefix = "VirtualNetwork" },
    "AllowSSHRDPOutbound2"                    = { priority = "165", direction = "Outbound", source_port = "*", destination_port = "3389", access = "Allow", protocol = "Tcp", source_address_prefix = "*", destination_address_prefix = "VirtualNetwork" },
    "AllowAzureCloudOutbound2"                = { priority = "170", direction = "Outbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "Tcp", source_address_prefix = "*", destination_address_prefix = "AzureCloud" },
    "AllowAzureBastionCommunicationOutbound1" = { priority = "180", direction = "Outbound", source_port = "*", destination_port = "5701", access = "Allow", protocol = "Tcp", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowAzureBastionCommunicationOutbound2" = { priority = "185", direction = "Outbound", source_port = "*", destination_port = "8080", access = "Allow", protocol = "Tcp", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowGetSessionInformation"              = { priority = "190", direction = "Outbound", source_port = "*", destination_port = "80", access = "Allow", protocol = "Tcp", source_address_prefix = "*", destination_address_prefix = "*" },
  }
  description = "The Standard list of NSG rules needed to make a bastion work"
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}
