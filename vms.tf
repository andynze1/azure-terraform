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
