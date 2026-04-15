terraform {
  required_version = ">= 1.3.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
  }
}


provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy               = true
      recover_soft_deleted_key_vaults            = true
      purge_soft_deleted_secrets_on_destroy      = true
      purge_soft_deleted_certificates_on_destroy = true
      purge_soft_deleted_keys_on_destroy         = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      skip_shutdown_and_force_delete = false
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
  }

  # Optional: specify subscription / tenant / service principal
  # subscription_id = var.subscription_id
  # tenant_id       = var.tenant_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret

  # Optional: use managed identity
  # use_msi = true

  # Optional: use OIDC for GitHub Actions / Azure DevOps
  # use_oidc = true

  # Optional: use Azure CLI
  # use_cli = true

  # Optional: environment (public, usgovernment, german, china)
  # environment = "public"
}

# ─── Azure API (azapi) ────────────────────────────────────────────────────────
# Required by AVM modules: avm-res-automation-automationaccount,
# avm-res-servicebus-namespace, avm-res-eventgrid-topic,
# avm-res-storage-storageaccount.
# Allows direct ARM REST API calls for resources not yet in azurerm.

provider "azapi" {
  # Inherits the same credential chain as azurerm (Azure CLI / OIDC / MSI / SP).
  # Set explicitly only when you need a different auth context.
  # subscription_id = var.subscription_id
  # tenant_id       = var.tenant_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
}
