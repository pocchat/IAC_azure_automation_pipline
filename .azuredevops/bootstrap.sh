#!/usr/bin/env bash
# ============================================================
# bootstrap.sh
# Run ONCE to create the Azure Blob Storage backend for
# Terraform remote state, then commit backend.tf.
#
# Usage:
#   chmod +x bootstrap.sh
#   ./bootstrap.sh
# ============================================================
set -euo pipefail

LOCATION="eastus"
RG_NAME="tfstate-rg"
SA_NAME="tfstate$(openssl rand -hex 4)"   # globally unique
CONTAINER="tfstate"

echo "Creating resource group: $RG_NAME"
az group create --name "$RG_NAME" --location "$LOCATION"

echo "Creating storage account: $SA_NAME"
az storage account create \
  --name "$SA_NAME" \
  --resource-group "$RG_NAME" \
  --location "$LOCATION" \
  --sku "Standard_LRS" \
  --kind "StorageV2" \
  --min-tls-version "TLS1_2" \
  --allow-blob-public-access false

echo "Creating blob container: $CONTAINER"
az storage container create \
  --name "$CONTAINER" \
  --account-name "$SA_NAME" \
  --auth-mode login

echo ""
echo "============================================================"
echo "Bootstrap complete. Update backend.tf with:"
echo "  storage_account_name = \"$SA_NAME\""
echo ""
echo "Then set these Azure DevOps pipeline variables:"
echo "  TF_BACKEND_RG        = $RG_NAME"
echo "  TF_BACKEND_SA        = $SA_NAME"
echo "  TF_BACKEND_CONTAINER = $CONTAINER"
echo "============================================================"
