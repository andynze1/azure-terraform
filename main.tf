terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.111.0"
    }
  }

}

# Resource Group
resource "azurerm_resource_group" "myresource-group01" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Virtial network - VPC
resource "azurerm_virtual_network" "dml-VirtualNetwork" {
  name                = var.virtual_network.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.virtual_network.address_space
  tags = {
    environment = "DML-Virtual-Private-Network"
  }
  depends_on = [azurerm_resource_group.myresource-group01]
}

# Public Subnet
resource "azurerm_subnet" "public-subnet" {
  name                 = var.public_subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.dml-VirtualNetwork.name
  address_prefixes     = [var.public_subnet.address_prefix]
  depends_on           = [azurerm_virtual_network.dml-VirtualNetwork]
}

# Private Subnet
resource "azurerm_subnet" "private-subnet" {
  name                 = var.private_subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.dml-VirtualNetwork.name
  address_prefixes     = [var.private_subnet.address_prefix]
  depends_on           = [azurerm_virtual_network.dml-VirtualNetwork]
}

# Public IP address
resource "azurerm_public_ip" "public-ip" {
  name                = var.azurerm_public_ip
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  depends_on          = [azurerm_virtual_network.dml-VirtualNetwork]
}

# Network interface
resource "azurerm_network_interface" "dml-network-interface" {
  name                = "dml-network-interface"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip.id
  }
  depends_on = [azurerm_subnet.public-subnet]
}

# Security Groups
# resource "azurerm_network_security_group" "dml-security-group" {

resource "azurerm_network_interface_security_group_association" "networksgasso" {
  network_interface_id      = azurerm_network_interface.dml-network-interface.id
  network_security_group_id = azurerm_network_security_group.dml-security-group.id
  depends_on                = [azurerm_network_security_group.dml-security-group]
}

resource "azurerm_subnet_network_security_group_association" "subnetasso" {
  subnet_id                 = azurerm_subnet.public-subnet.id
  network_security_group_id = azurerm_network_security_group.dml-security-group.id
}

# Virtual Machine - EC2
resource "azurerm_linux_virtual_machine" "jenkins-server" {
  name                = "jenkins-server"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "AndyBest1"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("azure-keypair.pub")
  }
  network_interface_ids = [azurerm_network_interface.dml-network-interface.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = filebase64("install.sh")
  depends_on  = [azurerm_network_interface.dml-network-interface, azurerm_resource_group.myresource-group01]
}


# # Storage Account
# resource "azurerm_storage_account" "appstorage1984" {
#   name                     = "appstorage1984"
#   resource_group_name      = var.resource_group_name
#   location                 = var.resource_group_location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"
#   depends_on               = [azurerm_resource_group.myresource-group01]
# }

# # Storage Container
# resource "azurerm_storage_container" "appfolder01" {
#   name                 = "appfolder01"
#   storage_account_name = azurerm_storage_account.appstorage1984.name
#   depends_on           = [azurerm_storage_account.appstorage1984]
# }

## Associating SG to subnet ensures all VM under the subnet takes same rules
# resource "azurerm_subnet_network_security_group_association" "sg-asso" {
#   subnet_id = azurerm_subnet.public-subnet.id
#   network_security_group_id = azurerm_network_security_group.dml-security-group.id
#   depends_on = [
#     azurerm_network_security_group.dml-security-group
#   ]
# }

# Public Subnet
# resource "azurerm_subnet" "public-subnet" {
#   name                 = var.subnets[0].name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.dml-VirtualNetwork.name
#   address_prefixes     = [var.subnets[0].address_prefix]
#   depends_on           = [ azurerm_virtual_network.dml-VirtualNetwork ]
# }

# # Private Subnet
# resource "azurerm_subnet" "private-subnet" {
#   name                 = var.subnets[1].name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.dml-VirtualNetwork.name
#   address_prefixes     = [var.subnets[1].address_prefix]
#   depends_on           = [ azurerm_virtual_network.dml-VirtualNetwork ]
# }