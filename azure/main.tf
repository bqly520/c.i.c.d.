provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  # version = "=2.0.0"
  features {}
}

provider "azuread" {
}

resource "azurerm_resource_group" "bobo-rg" {
  name     = "${var.prefix}-resources"
  location = var.location
}