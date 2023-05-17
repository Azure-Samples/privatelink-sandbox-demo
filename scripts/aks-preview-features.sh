#!/bin/bash

az extension add --name aks-preview
az extension update --name aks-preview

features=(
    "EnableAPIServerVnetIntegrationPreview"
    "AzureServiceMeshPreview"
    "NodeOsUpgradeChannelPreview"
    "EnableImageCleanerPreview"
    "AKS-ExtensionManager"
    "AzureOverlayPreview"
    "EnableAzureDiskCSIDriverV2"
    "AKS-AzureDefender"
)

for feature in ${features[*]}
do
    az feature register --namespace Microsoft.ContainerService --name $feature
done 

watch -n 10 -g az feature list --namespace Microsoft.ContainerService -o table --query \"[?properties.state == \'Registering\']\"

az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration

az extension add --name k8s-extension