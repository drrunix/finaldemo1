terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group

resource "azurerm_resource_group" "demo" {
  name     = "vmmaster"
  location = var.location
  tags = {
    environment = "Dev"
    project   = "MyLab"
    owner     = "RD"
   }
}

