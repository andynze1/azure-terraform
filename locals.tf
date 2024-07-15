locals {
  resource_group_name = "nzecruze-resource-group"
  location            = "East US"
  common_tags = {
    "environment" = "stageing"
    "tier"        = 3
    "department"  = "IT"
  }
  networksescuritygroup_rules = [
    {
      priority               = 200
      destination_port_range = "22", source_address_prefix = var.my_ip_address
    },
    {
      priority               = 300
      destination_port_range = "8080"
    },
    {
      priority               = 400
      destination_port_range = "8081"
    },
    {
      priority               = 500
      destination_port_range = "9000"
    },
    # {
    #   priority               = 600
    #   destination_port_range = "3389"
    # },
    {
      priority               = 700
      destination_port_range = "80"
    }
  ]
}