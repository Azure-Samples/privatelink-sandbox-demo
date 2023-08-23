variable "region" {
  description = "Region to deploy in Azure"
  default     = "southcentralus"
}

variable "firewall_policy_name" {
  description = "Name of the fireall policy to be used"
}

variable "firewall_policy_rg_name" {
  description = "Firewall Policy Resource Group name"
}

variable "core_subscription" {
  description = "Core Subscription"
}

variable "core_private_endpoint_rg_name" {
  description = "The Resource Group name where the private endpoint should in created the Core network"
}

variable "core_private_endpoint_virutalnetwork_rg_name" {
  description = "The Resource Group name of the virtual network where the private endpoint for ACR should be placed in the Core network"
}

variable "core_private_endpoint_virutalnetwork_name" {
  description = "The Virtual Network name where the private endpoint for ACR should be placed in the Core network"
}

variable "core_dns_rg_name" {
  description = "The Resource Group name of the DNS zone privatelink.azurecr.io in the Core Network"
}

variable "vm_sku" {
  description = "The SKU for the default node pool"
  default     = "Standard_D4ads_v5" 
}

variable "ingress_namespace" {
  description = "The namespace where the Istio ingress will be deployed to"
  default     = "aks-istio-ingress"   
}

variable "branch_name" {
  description = "Git branched used by flux"
  default     = "main"
} 

variable "deploy_cosmosdb" {
  description = "Deploy Azure Cosmos DB as part of this Sandbox"
  default     = false 
}

variable "deploy_eventhub" {
  description = "Deploy Azure Event Hub as part of this Sandbox"
  default     = false 
}

variable "deploy_private_link_service" {
  description = "Deploy Azure Private Link Service for AKS Ingress as part of this Sandbox"
  default     = false 
}