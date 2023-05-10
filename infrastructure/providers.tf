terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.55.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias           = "core"
  features        {}

  subscription_id = var.core_subscription
}

provider "azapi" {
}
