resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    azapi_update_resource.istio_ingressgateway
  ]
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.aks.id
  extension_type = "microsoft.flux"
}


resource "azapi_resource" "flux_config" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]

  type      = "Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01"
  name      = "aks-flux-extension"
  parent_id = azurerm_kubernetes_cluster.aks.id

  body = jsonencode({
    properties : {
      scope      = "cluster"
      namespace  = "flux-system"
      sourceKind = "GitRepository"
      suspend    = false
      gitRepository = {
        url                   = local.flux_repository
        timeoutInSeconds      = 600
        syncIntervalInSeconds = 300
        repositoryRef = {
          branch = "main"
        }
      }
      kustomizations : {
        apps = {
          path                   = local.cluster_path
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
      }
    }
  })
}