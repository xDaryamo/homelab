# --- Service Principal for External Secrets Operator ---

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
