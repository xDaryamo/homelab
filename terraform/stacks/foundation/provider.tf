terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "5.8.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}
