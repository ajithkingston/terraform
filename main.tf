# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform-rg" {
  name     = "Terraform-RG"
  location = "southindia"
  tags = {
    owner      = "Ajith"
    env        = "dev"
    costcentre = "hands-on"
  }

}

resource "azurerm_resource_group" "tfstate-rg" {
  name     = "TFSTATE-RG"
  location = "southindia"

  tags = {
    owner      = "Ajith"
    env        = "dev"
    costcentre = "hands-on"
  }
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "mytfstatestorageaccount"
  resource_group_name      = azurerm_resource_group.tfstate-rg.name
  location                 = azurerm_resource_group.tfstate-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    owner      = "Ajith"
    env        = "dev"
    costcentre = "hands-on"
  }
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "mytfstatestoragecontainer"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "blob"

  #   tags = {
  #   owner      = "Ajith"
  #   env        = "dev"
  #   costcentre = "hands-on"
  # }
}