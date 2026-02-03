resource "azurerm_storage_account" "backup" {
  name                     = "stdariomazzahomelab" # Static name, must be globally unique
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Lowest cost option
  min_tls_version          = "TLS1_2"

  tags = {
    environment = "production"
    purpose     = "longhorn-backup"
  }
}

resource "azurerm_storage_container" "longhorn" {
  name                  = "longhorn-backups"
  storage_account_id    = azurerm_storage_account.backup.id
  container_access_type = "private"
}