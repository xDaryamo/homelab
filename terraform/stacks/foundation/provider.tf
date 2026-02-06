terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}
