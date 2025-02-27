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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
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

# # Configure the Azure provider
# provider "azurerm" {
#   features {}
# }

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "southindia"
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a network security group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create a public IP address
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Create a network interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s" # Free tier eligible size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/Ajith Kingston/Documents/GitHub/terraform/id_rsa.pub") # Replace with your public key path
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Output the public IP address of the VM
output "public_ip_address" {
  value = azurerm_public_ip.example.ip_address
}

# resource "azurerm_resource_group" "tfstate-rg" {
#   name     = "TFSTATE-RG"
#   location = "southindia"

#   tags = {
#     owner      = "Ajith"
#     env        = "dev"
#     costcentre = "hands-on"
#   }
# }




# resource "azurerm_storage_account" "storageaccount" {
#   name                     = "mytfstatestorageaccount"
#   resource_group_name      = azurerm_resource_group.tfstate-rg.name
#   location                 = azurerm_resource_group.tfstate-rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     owner      = "Ajith"
#     env        = "dev"
#     costcentre = "hands-on"
#   }
# }

# resource "azurerm_storage_container" "storagecontainer" {
#   name                  = "mytfstatestoragecontainer"
#   storage_account_name  = azurerm_storage_account.storageaccount.name
#   container_access_type = "private"

# }

# resource "azurerm_resource_group" "JavaSpringSampleDeploy-RG" {
#   name     = "JavaSpringSampleDeploy-RG"
#   location = "East US"

#   tags = {
#     owner      = "Ajith"
#     env        = "dev"
#     costcentre = "hands-on"
#   }
# }

# resource "azurerm_service_plan" "azurermserviceplan" {
#   name                = "JavaSpringSampleDeployServicePlan"
#   location            = "East US"
#   resource_group_name = "JavaSpringSampleDeploy-RG"
#   os_type             = "Linux"
#   sku_name            = "F1"

#   depends_on = [
#     azurerm_resource_group.JavaSpringSampleDeploy-RG
#   ]
# }

# resource "azurerm_linux_web_app" "azureappservice" {
#   name                = "JavaSpringSampleDeploy"
#   location            = "East US"
#   resource_group_name = "JavaSpringSampleDeploy-RG"
#   service_plan_id     = azurerm_service_plan.azurermserviceplan.id

#   site_config {
#     use_32_bit_worker = true
#     always_on = false
#     app_command_line = "java -jar /home/site/wwwroot/spring-azure-demo-0.0.1-SNAPSHOT.jar"
#   }

#   depends_on = [
#     azurerm_resource_group.JavaSpringSampleDeploy-RG
#   ]

# }
