# --- Grafana App Registration ---
resource "azuread_application" "grafana" {
  display_name     = "homelab-grafana"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg" # Single Tenant

  web {
    redirect_uris = [
      "${var.grafana_url}/login/azuread"
    ]
  }

  # Optional claims for group mapping allow Grafana to see user groups
  optional_claims {
    id_token {
      name = "groups"
    }
    access_token {
      name = "groups"
    }
  }

  group_membership_claims = ["SecurityGroup"]
}

resource "azuread_service_principal" "grafana" {
  client_id                    = azuread_application.grafana.client_id
  app_role_assignment_required = false # If true, users must be assigned to the app
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "time_offset" "grafana_password_expiry" {
  offset_years = 1
}

resource "azuread_application_password" "grafana" {
  application_id = azuread_application.grafana.id
  display_name   = "grafana-k8s-secret"
  end_date       = time_offset.grafana_password_expiry.rfc3339
}

# --- Save Secrets to Key Vault ---

resource "azurerm_key_vault_secret" "grafana_client_id" {
  name         = "grafana-client-id"
  value        = azuread_application.grafana.client_id
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "grafana_client_secret" {
  name         = "grafana-client-secret"
  value        = azuread_application_password.grafana.value
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "grafana_tenant_id" {
  name         = "grafana-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = azurerm_key_vault.main.id
}
