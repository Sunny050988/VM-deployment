terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1"
    }
  }
}

provider "azurerm" {
  features {}   
    resource_provider_registrations = "none"
  subscription_id = "0981cc9e-5ac2-492e-958d-0b05878bb988"
}