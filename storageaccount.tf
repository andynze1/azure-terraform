### Storage and Container Resource Samples


# Create Storage Account
resource "azurerm_storage_account" "storageaccountresource" {
  name = "appstorage1984"
  #  name                     = join("",["${var.storage_account_name}",substr(random_uuid.storageaccountidentifier.result,0,8)])
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  #   network_rules {
  #     default_action = "Deny"
  #     ip_rules = ["146.85.136.101"]
  #     virtual_network_subnet_ids = [azurerm_subnet.public-subnet.id]
  # ###   service_endpoints = ["Microsoft.Storage"] check in public subnet    
  #   }
  depends_on = [
    azurerm_resource_group.nzecruze-resource-group,
    # random_uuid.storageaccountidentifier,
  ]
  tags = {
    for name, value in local.common_tags : name => "${value}"
  }
}

# Create multiple Storage Containers using count
# resource "azurerm_storage_container" "appcontainer" {
#   name                  = "appcontainer"
# #  count                 = 2
#   storage_account_name  = azurerm_storage_account.storageaccountresource.name
#   container_access_type = "blob"
#   depends_on = [
#     azurerm_storage_account.storageaccountresource,
#   ]
# }

# Copy one files install.sh into one container data
# resource "azurerm_storage_blob" "files" {
#   name                   = "install.sh"
#   storage_account_name   = azurerm_storage_account.storageaccountresource.name
#   storage_container_name = "appcontainer"
#   type                   = "Block"
#   source                 = "app-scripts/install.sh"
#   depends_on = [ 
#     azurerm_resource_group.nzecruze-resource-group, 
#     azurerm_storage_container.appcontainer,
#   ]
# }

# resource "random_uuid" "storageaccountidentifier" {

# }

# output "randomid" {
#   value=substr(random_uuid.storageaccountidentifier.result,0,8)
# }