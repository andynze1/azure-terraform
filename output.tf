output "public_subnet" {
  value = azurerm_subnet.public-subnet.id
}

output "azurerm_linux_virtual_machine" {
  value = azurerm_linux_virtual_machine.jenkins-server.id
}