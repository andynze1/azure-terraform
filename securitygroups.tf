resource "azurerm_network_security_group" "dml-security-group" {
  name                = "dml-security-group"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dynamic "security_rule" {
    for_each = {
      "SSH_Port_22"         = { priority = 1001, destination_port_range = "22", source_address_prefix = var.my_ip_address },
      "Jenkins_Port_8080"   = { priority = 1002, destination_port_range = "8080" },
      "SonarQube_Port_8081" = { priority = 1003, destination_port_range = "8081" },
      "Nexus_Port_9000"     = { priority = 1004, destination_port_range = "9000" },
    }
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = lookup(security_rule.value, "source_address_prefix", "*")
      destination_address_prefix = "*"
    }
  }
  tags = {
    environment = "Development"
  }
  depends_on = [azurerm_virtual_network.dml-VirtualNetwork]
}