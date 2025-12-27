# Set the Azure Provider source and version being used
terraform {
  required_version = "~> 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.64.0"
    }
  }
}

# Configure the Microsoft Azure provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}
