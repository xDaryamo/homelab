terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.62.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}
