terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "5.2.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}
