resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    #azapi_update_resource.updates
    azurerm_kubernetes_cluster.aks
  ]
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.aks.id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "flux_config" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]

  name       = "aks-flux-extension"
  cluster_id = azurerm_kubernetes_cluster.aks.id
  namespace  = "flux-system"
  scope      = "cluster"

  git_repository {
    url                      = local.flux_repository
    reference_type           = "branch"
    reference_value          = local.branch_name
    timeout_in_seconds       = 600
    sync_interval_in_seconds = 30
  }

  kustomizations {
    name                       = "apps"
    path                       = local.cluster_path
    timeout_in_seconds         = 600
    sync_interval_in_seconds   = 120
    retry_interval_in_seconds  = 300
    garbage_collection_enabled = true
  }
}