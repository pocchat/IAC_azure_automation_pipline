# ============================================================
# Remote Backend – Azure Blob Storage
# This file is used by the pipeline.
# For LOCAL development, comment this block out and let
# provider.tf use local state, OR run:
#
#   terraform init \
#     -backend-config="resource_group_name=<rg>" \
#     -backend-config="storage_account_name=<sa>" \
#     -backend-config="container_name=tfstate" \
#     -backend-config="key=IAC_azure_automation_pipeline/terraform.tfstate"
#
# REQUIRED Azure resources (run bootstrap.sh once):
#   - Resource group : tfstate-rg
#   - Storage account: tfstateXXXXXX   (globally unique)
#   - Container      : tfstate
# ============================================================

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatecb2b7785"
    container_name       = "tfstate"
    key                  = "IAC_azure_automation_pipeline/terraform.tfstate"
  }
}
