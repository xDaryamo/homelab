data "azurerm_client_config" "current" {}

data "terraform_remote_state" "foundation" {
  backend = "local"

  config = {
    path = "${path.module}/../foundation/terraform.tfstate"
  }
}

data "azurerm_resource_group" "rg" {
  name = data.terraform_remote_state.foundation.outputs.resource_group_name
}

# Common Azure AD configuration used by both Grafana and External Secrets
data "azuread_client_config" "current" {}