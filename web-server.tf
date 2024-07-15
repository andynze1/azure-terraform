# Virtual Machine - EC2
resource "azurerm_linux_virtual_machine" "jenkins-server" {
  name                = "jenkins-server"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  # admin_password      = "AndyBest1"
  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.ubuntu-keypair.public_key_openssh
  }
  # count = 2
  # admin_ssh_key {
  #   username   = "azure-user"
  #   public_key = file("east-us-keypair.pub")
  # }
  network_interface_ids = [azurerm_network_interface.nzecruze-network-interface.id]
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
  # bootstrap
  # custom_data = base64encode(data.template_file.cloudinitdata.rendered)
  custom_data = filebase64("${path.module}/app-scripts/install.sh")

  depends_on = [
    azurerm_network_interface.nzecruze-network-interface,
    azurerm_resource_group.nzecruze-resource-group,
    tls_private_key.ubuntu-keypair
  ]
  tags = {
    for name, value in local.common_tags : name => "${value}"
  }
}

#bootstrap
# data "template_file" "cloudinitdata" {
#   template = file("app-scripts/install.sh")
# }


## resource "azurerm_managed_disk" "jenkins_srv_disk" {
#   name                 = "jenkinsdisk"
#   location             = var.resource_group_location
#   resource_group_name  = var.resource_group_name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "16"
#   depends_on = [ azurerm_resource_group.myresource-group01 ]
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "jenkins_srv_disk_attach" {
#   managed_disk_id    = azurerm_managed_disk.jenkins_srv_disk.id
#   virtual_machine_id = azurerm_linux_virtual_machine.jenkins-server.id
#   lun                = "0"
#   caching            = "ReadWrite"
#   depends_on = [ azurerm_managed_disk.jenkins_srv_disk ]
# }