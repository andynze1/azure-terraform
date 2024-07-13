# Virtial network - VPC
resource "azurerm_virtual_network" "andytech-virtual-network" {
  name                = var.virtual_network.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.virtual_network.address_space
  tags = {
    environment = "Andytech-Virtual-Private-Network"
  }
  depends_on = [azurerm_resource_group.andytech-resource-group01]
}

# Public Subnet
resource "azurerm_subnet" "public-subnet" {
  name                 = var.public_subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.andytech-virtual-network.name
  address_prefixes     = [var.public_subnet.address_prefix]
  depends_on           = [azurerm_virtual_network.andytech-virtual-network]
}

# Private Subnet
resource "azurerm_subnet" "private-subnet" {
  name                 = var.private_subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.andytech-virtual-network.name
  address_prefixes     = [var.private_subnet.address_prefix]
  depends_on           = [azurerm_virtual_network.andytech-virtual-network]
}

# Public IP address
resource "azurerm_public_ip" "public-ip" {
  name                = var.azurerm_public_ip
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  depends_on          = [azurerm_virtual_network.andytech-virtual-network]
}

/*
variable "azurerm_public_ip" {
  description = "Pubic IP Address"
  type        = string
  default     = "public-ip"
}
*/
# Network interface
resource "azurerm_network_interface" "andytech-network-interface" {
  name                = "andytech-network-interface"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip.id
  }
  depends_on = [azurerm_resource_group.andytech-resource-group01, azurerm_virtual_network.andytech-virtual-network, azurerm_subnet.public-subnet]
}