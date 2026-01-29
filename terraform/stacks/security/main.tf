data "azurerm_client_config" "current" {}

data "terraform_remote_state" "foundation" {
  backend = "local"

  config = {
    path = "${path.module}/../foundation/terraform.tfstate"
  }
}

data "azurerm_resource_group" "rg" {
  name = data.terraform_remote_state.foundation.outputs.resource_group_name
}

# --- Service Principal for External Secrets Operator ---
data "azuread_client_config" "current" {}

resource "azuread_application" "external_secrets" {
  display_name = "sp-external-secrets-homelab"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "external_secrets" {
  client_id                    = azuread_application.external_secrets.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "external_secrets" {
  service_principal_id = azuread_service_principal.external_secrets.id
}

# --- Key Vault ---

resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  # Admin Policy
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }

  # External Secrets Operator Policy
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azuread_service_principal.external_secrets.object_id

    secret_permissions = [
      "Get", "List"
    ]
  }
}

