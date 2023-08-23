# Instruction Build Steps 

## Components Created
Component | Usage
------ | ------
Azure Kubernetes Service | Container Orchestration Runtime Platform  
Azure Key Vault | Secret and Certificate store 
Azure Container Registry | Azure Container Registry for containers
Azure Virtual Network  | Azure Virtual Network for all resources and private endpoints
Azure Firewall | Egress Management 
Azure Cosmos DB | NoSQL Data storage (Optional)
Azure Event Hub | Event Streaming Solution (Optional)
Azure Private Link Service | Exposes AKS Ingress Control back to your Azure Core (Optional)

## Required Existing Resources and Configuration
Component | Usage
--------------- | --------------- 
| Two Azure Subscriptions | Application Subscription and Core Subscription |
| Identity granted Owner permissions over each subscription |
| Azure Virtual Network (Core) | A subnet for Private Endpoints |
| Azure VPN Gateway | |
| Azure Firewall Policy | [Required Rules](https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress)
| Private DNS Zones (attached to Core Vnet) | privatelink.azurecr.io |

## Required Tools Install
* Use Github Codespaces with DevContainers
* If CodeSpaces is unavaible then install the following locally: 
    * [Terraform](https://developer.hashicorp.com/terraform/downloads)
    * [Azure Cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Application Azure Subscriptions Requirments
* Two Azure Subscription with Owner permissions
* AKS Preview Features Registered: 
    * EnableAPIServerVnetIntegrationPreview
    * AzureServiceMeshPreview
    * NodeOsUpgradeChannelPreview
    * EnableImageCleanerPreview
    * AKS-ExtensionManager
    * AzureOverlayPreview
    * EnableAzureDiskCSIDriverV2
    * AKS-AzureDefender
* The following script can register all required preview features: `bash ./scripts/aks-preview-features.sh`

## Infrastructure Build
1. Fork this repository into your own Github repository
1. Deploy the infrastructure
```bash
    vi ./infrastructure/azure.tfvars
    #core_subscription                            = "557f5d52-bffc-4582-bd0b-2cd706813031"
    #core_private_endpoint_virutalnetwork_name    = "Core-VNet-001"
    #core_private_endpoint_virutalnetwork_rg_name = "Core_Network_RG"
    #core_dns_rg_name                             = "Core_DNS_RG"
    #core_private_endpoint_rg_name                = "Core_PrivateEndpoints_RG"
    #firewall_policy_rg_name                      = "Core_Firewall_RG"
    #firewall_policy_name                         = "proxy-southcentral-policy"
    #deploy_cosmosdb                              = true
    #deploy_eventhub                              = false
    #branch_name                                  = "test-cluster"

    az login --scope https://graph.microsoft.com/.default #Code requires AAD permissions 
    terraform -chdir=./infrastructure workspace new southcentralus || true
    terraform -chdir=./infrastructure workspace select southcentralus
    terraform -chdir=./infrastructure init
    terraform -chdir=./infrastructure apply -auto-approve -var "region=southcentralus" -var-file="./azure.tfvars"
    bash ./scripts/setup-dns-records.sh 
```
1. Search and Replace `replace_me_with_dynamic_keyvault_name` with the name of the Key Vault created by Terraform
1. Search and Replace `replace_me_with_istio_managed_identity_client_id` with the Client ID of the Istio Managed User Identity
1. Commit code and push to branch

## Destory Environment
```bash
    az login --scope https://graph.microsoft.com/.default
    terraform -chdir=./infrastructure destroy -auto-approve -var "region=southcentralus" -var-file="./infrastructure/azure.tfvars"
```