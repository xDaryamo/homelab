variable "location" {
  description = "The Azure region where the Key Vault will be created"
  type        = string
  default     = "italynorth"
}

variable "key_vault_name" {
  description = "The globally unique name of the Key Vault"
  type        = string
  default     = "kv-dariomazza-homelab" 
}

variable "grafana_url" {
  description = "The public URL for Grafana"
  type        = string
  default     = "https://grafana.dariomazza.net"
}