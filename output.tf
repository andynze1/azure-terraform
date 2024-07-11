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
  value       = azurerm_linux_virtual_machine.jenkins-server.public_ip_address
}

output "network_security_group_id" {
  description = "Network Security Group"
  value       = azurerm_network_security_group.dml-security-group.name
}