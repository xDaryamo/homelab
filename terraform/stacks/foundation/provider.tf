terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.75.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}
