output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "resource_group_id" {
  value = azurerm_resource_group.main.id
}

output "storage_account_name" {
  value = azurerm_storage_account.backup.name
}

output "storage_container_name" {
  value = azurerm_storage_container.longhorn.name
}

output "storage_primary_access_key" {
  value     = azurerm_storage_account.backup.primary_access_key
  sensitive = true
}