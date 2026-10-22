# --- Sure App Registration (OIDC SSO) ---
resource "azuread_application" "sure" {
  display_name     = "homelab-sure"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg" # Single Tenant

  web {
    redirect_uris = [
      "https://finance.dariomazza.net/auth/openid_connect/callback"
    ]
  }

  # Sure matches SSO identities to existing users by email
  optional_claims {
    id_token {
      name = "email"
    }
  }
}

resource "azuread_service_principal" "sure" {
  client_id                    = azuread_application.sure.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "time_offset" "sure_password_expiry" {
  offset_years = 1
}

resource "azuread_application_password" "sure" {
  application_id = azuread_application.sure.id
  display_name   = "sure-k8s-secret"
  end_date       = time_offset.sure_password_expiry.rfc3339
}

# --- Save Secrets to Key Vault ---

resource "azurerm_key_vault_secret" "sure_client_id" {
  name         = "sure-client-id"
  value        = azuread_application.sure.client_id
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "sure_client_secret" {
  name         = "sure-client-secret"
  value        = azuread_application_password.sure.value
  key_vault_id = azurerm_key_vault.main.id
}
