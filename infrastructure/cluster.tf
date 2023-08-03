data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  depends_on = [ 
    azurerm_subnet_route_table_association.api,
    azurerm_subnet_route_table_association.nodes,
  ]
  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
    ]
  }

  name                                = local.aks_name
  resource_group_name                 = azurerm_resource_group.this.name
  location                            = azurerm_resource_group.this.location
  node_resource_group                 = "${local.resource_name}_k8s_nodes_rg"
  private_cluster_enabled             = true
  dns_prefix_private_cluster          = local.aks_name
  private_dns_zone_id                 = azurerm_private_dns_zone.aks_private_zone.id
  private_cluster_public_fqdn_enabled = false
  kubernetes_version                  = data.azurerm_kubernetes_service_versions.current.latest_version
  sku_tier                            = "Free"
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  open_service_mesh_enabled           = false
  azure_policy_enabled                = true
  local_account_disabled              = true
  role_based_access_control_enabled   = true
  automatic_channel_upgrade           = "patch"
  node_os_channel_upgrade             = "NodeImage"
  image_cleaner_enabled               = true
  image_cleaner_interval_hours        = "48"

  api_server_access_profile {
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.api.id
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    tenant_id              = data.azurerm_client_config.current.tenant_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet_identity.id
  }

  service_mesh_profile {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = true
  }

  default_node_pool {
    name                = "default"
    node_count          = 3
    vm_size             = var.vm_sku
    os_disk_size_gb     = 90
    vnet_subnet_id      = azurerm_subnet.nodes.id
    os_sku              = "Mariner"
    os_disk_type        = "Ephemeral"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 9
    max_pods            = 40

    upgrade_settings {
      max_surge = "33%"
    }
  }

  network_profile {
    dns_service_ip      = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr        = "100.${random_integer.services_cidr.id}.0.0/16"
    pod_cidr            = "100.${random_integer.pod_cidr.id}.0.0/16"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
    outbound_type       = "userDefinedRouting"
  }

  maintenance_window_auto_upgrade {
    frequency = "Weekly"
    interval  = 1
    duration  = 4
    day_of_week = "Friday"
    utc_offset = "-06:00"
    start_time = "20:00"
  }

  maintenance_window_node_os {
    frequency = "Weekly"
    interval  = 1
    duration  = 4
    day_of_week = "Saturday"
    utc_offset = "-06:00"
    start_time = "20:00"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "5m"
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

  storage_profile {
    blob_driver_enabled = true
    disk_driver_enabled = true
    file_driver_enabled = true
  }

}
