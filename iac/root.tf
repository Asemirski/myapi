terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.80.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "random_string" "numbers" {
  length  = 5
  upper   = false
  numeric = true
  special = false
}

data "azurerm_client_config" "current" {}