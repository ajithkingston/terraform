terraform {
    backend "azurerm" {
        resource_group_name  = "TFSTATE-RG"
        storage_account_name = "mytfstatestorageaccount"
        container_name       = "mytfstatestoragecontainer"
        key                  = "terraform.tfstate"
    }
}