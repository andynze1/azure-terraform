resource "azurerm_network_security_group" "dml-security-group" {
  name                = "dml-security-group"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dynamic "security_rule" {
    for_each = {
      "SSH"        = { priority = 1001, destination_port_range = "22" },
      "HTTP"       = { priority = 1002, destination_port_range = "8080" },
      "HTTP-8081"  = { priority = 1003, destination_port_range = "8081" },
      "NEXUS-9000" = { priority = 1004, destination_port_range = "9000" },
    }
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*" // "146.85.137.76/32"
      destination_address_prefix = "*"
    }
  }
  depends_on = [azurerm_virtual_network.dml-VirtualNetwork]
}