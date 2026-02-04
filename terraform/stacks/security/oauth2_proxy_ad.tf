# --- OAuth2 Proxy App Registration ---
resource "azuread_application" "oauth2_proxy" {
  display_name     = "homelab-oauth2-proxy"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg" # Single Tenant

  web {
    redirect_uris = [
      "https://auth.dariomazza.net/oauth2/callback"
    ]
  }

  group_membership_claims = ["SecurityGroup"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "oauth2_proxy" {
  client_id                    = azuread_application.oauth2_proxy.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "oauth2_proxy" {
  application_id = azuread_application.oauth2_proxy.id
  display_name   = "oauth2-proxy-k8s-secret"
  end_date       = time_offset.grafana_password_expiry.rfc3339 # Reuse expiry logic
}

# --- Cookie Secret for OAuth2 Proxy ---
resource "random_password" "oauth2_proxy_cookie_secret" {
  length  = 32
  special = false
}

# --- Save Secrets to Key Vault ---

resource "azurerm_key_vault_secret" "oauth2_proxy_client_id" {
  name         = "oauth2-proxy-client-id"
  value        = azuread_application.oauth2_proxy.client_id
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "oauth2_proxy_client_secret" {
  name         = "oauth2-proxy-client-secret"
  value        = azuread_application_password.oauth2_proxy.value
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "oauth2_proxy_cookie_secret" {
  name         = "oauth2-proxy-cookie-secret"
  value        = random_password.oauth2_proxy_cookie_secret.result
  key_vault_id = azurerm_key_vault.main.id
}
