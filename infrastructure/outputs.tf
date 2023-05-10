output "AKS_RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = local.aks_name
    sensitive = false
}

output "APP_NAME" {
    value = local.resource_name
    sensitive = false
}