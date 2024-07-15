
# Resource Group
resource "azurerm_resource_group" "nzecruze-resource-group" {
  name     = local.resource_group_name
  location = var.resource_group_location
}



# Security Groups
# resource "azurerm_network_security_group" "nzecruze-security-group" 



# resource "azurerm_subnet_network_security_group_association" "subnetasso" {
#   subnet_id                 = azurerm_subnet.public-subnet.id
#   network_security_group_id = azurerm_network_security_group.nzecruze-security-group.id
# }


# # Create different containers using for_each
# resource "azurerm_storage_container" "datas" {
#   for_each = toset (["data", "files", "documents"])
#   name = each.key
#   storage_account_name  = azurerm_storage_account.appstorage1984.name
#   container_access_type = "blob"
#   depends_on = [
#     azurerm_storage_account.appstorage1984
#   ]
# }

# # Copy different files into data container
# resource "azurerm_storage_blob" "copyfiles" {
#   for_each = {
#     dir1 = "../dir1/sample1.txt"
#     dir2 = "../dir2/sample2.txt"
#     dir3 = "../dir3/sample3.txt"
#   }
#   name                   = "${each.key}.txt"
#   storage_account_name   = azurerm_storage_account.appstorage1984.name
#   storage_container_name = "data"
#   type                   = "Block"
#   source                 = each.value
#   depends_on = [ azurerm_storage_container.datas ]
# }




## Associating SG to subnet ensures all VM under the subnet takes same rules
# resource "azurerm_subnet_network_security_group_association" "sg-asso" {
#   subnet_id = azurerm_subnet.public-subnet.id
#   network_security_group_id = azurerm_network_security_group.nzecruze-security-group.id
#   depends_on = [
#     azurerm_network_security_group.nzecruze-security-group
#   ]
# }

# Public Subnet
# resource "azurerm_subnet" "public-subnet" {
#   name                 = var.subnets[0].name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.nzecruze-virtual-network.name
#   address_prefixes     = [var.subnets[0].address_prefix]
#   depends_on           = [ azurerm_virtual_network.nzecruze-virtual-network ]
# }

# # Private Subnet
# resource "azurerm_subnet" "private-subnet" {
#   name                 = var.subnets[1].name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.nzecruze-virtual-network.name
#   address_prefixes     = [var.subnets[1].address_prefix]
#   depends_on           = [ azurerm_virtual_network.nzecruze-virtual-network ]
# }