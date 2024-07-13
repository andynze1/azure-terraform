# Create SSH RSA key of size 4096 bits
resource "tls_private_key" "ubuntu-keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Copy ssh key to local
resource "local_file" "ubuntu-pem-key" {
  content         = tls_private_key.ubuntu-keypair.private_key_pem
  filename        = "ubuntu-keypair.pem"
  file_permission = "0400"
  depends_on      = [tls_private_key.ubuntu-keypair]
}