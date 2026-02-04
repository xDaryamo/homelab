output "key_vault_id" {
  value = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "azure_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "sp_client_id" {
  value = azuread_service_principal.external_secrets.client_id
}

output "sp_client_secret" {
  value     = azuread_service_principal_password.external_secrets.value
  sensitive = true
}

# --- Grafana Auth Outputs ---

output "grafana_client_id" {
  value = azuread_application.grafana.client_id
}

output "grafana_client_secret" {
  value     = azuread_application_password.grafana.value
  sensitive = true
}

output "grafana_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}