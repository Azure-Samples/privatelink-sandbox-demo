# resource "azapi_update_resource" "updates" {
#   depends_on = [
#     azurerm_kubernetes_cluster.aks
#   ]

#   type        = "Microsoft.ContainerService/managedClusters@2023-03-02-preview"
#   resource_id = azurerm_kubernetes_cluster.aks.id

#   body = jsonencode({
#   })
# }
