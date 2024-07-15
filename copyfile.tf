resource "null_resource" "copyfile" {
  provisioner "file" {
    source = "app-scripts/install.sh"
    destination = "/tmp/install.sh"
    connection {
      type = "ssh"
      user = "adminuser"
      private_key = file("${local_file.ubuntu-pem-key.filename}")
      host = azurerm_public_ip.public-ip.ip_address
    }
  }
  depends_on = [ 
    local_file.ubuntu-pem-key,
    azurerm_linux_virtual_machine.jenkins-server
   ]
}
