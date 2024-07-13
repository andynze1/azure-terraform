output "Public_Subnet_IP" {
  description = "The ID of the public subnet."
  value       = azurerm_subnet.public-subnet.address_prefixes
}

output "Private_Subnet_IP" {
  description = "The ID of the private subnet."
  value       = azurerm_subnet.private-subnet.address_prefixes
}

output "Jenkins_Server" {
  description = "The IP of the Jenkins Server."
  value       = azurerm_linux_virtual_machine.build-server.public_ip_address
}

# output "Jenkins_Server" {
#   value = azurerm_linux_virtual_machine.build-server[0].public_ip_address
# }
# output "Jenkins_Server_Public_IPs" {
#   value = [for vm in azurerm_linux_virtual_machine.build-server : vm.public_ip_address]
# }

output "network_security_group_id" {
  description = "Network Security Group"
  value       = azurerm_network_security_group.andytech-security-group.name
}

