terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "5.6.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}
