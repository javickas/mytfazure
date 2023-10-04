

locals {
  app_user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools iperf3
sudo apt autoremove
EOF
}

##########################################################################
##########################################################################
####VM1-E1##
##########################################################################
##########################################################################


resource "azurerm_network_interface" "e-main" {
  name                = "${var.azure_spk1_e1_name}-nic1"
  resource_group_name = module.spoke_azure_E1.vpc.resource_group
  location            = var.azure-region-E1
  ip_configuration {
    name                          = module.spoke_azure_E1.vpc.private_subnets[0].name
    subnet_id                     = module.spoke_azure_E1.vpc.private_subnets[0].subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "e-spoke1-app" {
  name                = "spoke1-app-east"
  resource_group_name = module.spoke_azure_E1.vpc.resource_group
  location            = var.azure-region-E1
}

resource "azurerm_network_security_rule" "e-http" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "http"
  priority                    = 100
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "80"
  destination_address_prefix  = "*"
  resource_group_name         = module.spoke_azure_E1.vpc.resource_group
  network_security_group_name = azurerm_network_security_group.e-spoke1-app.name
}

resource "azurerm_network_security_rule" "e-ssh" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "ssh"
  priority                    = 110
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  resource_group_name         = module.spoke_azure_E1.vpc.resource_group
  network_security_group_name = azurerm_network_security_group.e-spoke1-app.name
}

resource "azurerm_network_security_rule" "e-icmp" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "icmp"
  priority                    = 120
  protocol                    = "Icmp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = module.spoke_azure_E1.vpc.resource_group
  network_security_group_name = azurerm_network_security_group.e-spoke1-app.name
}

resource "azurerm_network_interface_security_group_association" "e-main" {
  network_interface_id      = azurerm_network_interface.e-main.id
  network_security_group_id = azurerm_network_security_group.e-spoke1-app.id
}



resource "azurerm_linux_virtual_machine" "azure_e-spoke1_vm" {
  name                            = "${var.azure_spk1_e1_name}-app"
  resource_group_name             = var.rg
  location                        = var.azure-region-E1
  size                            = var.azure_vm_large_instance
  admin_username                  = "ubuntu"
  admin_password                  = var.az_linux_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.e-main.id,
  ]
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  custom_data = base64encode(local.app_user_data)


}

##########################################################################
##########################################################################
# ##
# ##VM EAST2
##########################################################################
##########################################################################

# resource "azurerm_network_interface" "e2-main" {
#   name                = "${var.azure_spk1_e2_name}-nic1"
#   resource_group_name = module.spoke_azure_E2.vpc.resource_group
#   location            = var.azure-region-E1
#   ip_configuration {
#     name                          = module.spoke_azure_E2.vpc.private_subnets[0].name
#     subnet_id                     = module.spoke_azure_E2.vpc.private_subnets[0].subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_network_security_group" "e-spoke2-app" {
#   name                = "spoke2-app-east"
#   resource_group_name = module.spoke_azure_E2.vpc.resource_group
#   location            = var.azure-region-E1
# }

# resource "azurerm_network_security_rule" "e2-http" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "http"
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "80"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E2.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke2-app.name
# }

# resource "azurerm_network_security_rule" "e2-ssh" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "ssh"
#   priority                    = 110
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E2.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke2-app.name
# }

# resource "azurerm_network_security_rule" "e2-icmp" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "icmp"
#   priority                    = 120
#   protocol                    = "Icmp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E2.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke2-app.name
# }

# resource "azurerm_network_interface_security_group_association" "e2-main" {
#   network_interface_id      = azurerm_network_interface.e2-main.id
#   network_security_group_id = azurerm_network_security_group.e-spoke2-app.id
# }



# resource "azurerm_linux_virtual_machine" "azure_e2-spoke1_vm" {
#   name                            = "${var.azure_spk1_e2_name}-app"
#   resource_group_name             = var.rg
#   location                        = var.azure-region-E1
#   size                            = var.azure_vm_large_instance
#   admin_username                  = "ubuntu"
#   admin_password                  = var.az_linux_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.e2-main.id,
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

#   custom_data = base64encode(local.app_user_data)


# }

##########################################################################
##########################################################################
##VM EAST3
##########################################################################
##########################################################################

# resource "azurerm_network_interface" "e3-main" {
#   name                = "${var.azure_spk1_e3_name}-nic1"
#   resource_group_name = module.spoke_azure_E3.vpc.resource_group
#   location            = var.azure-region-E1
#   ip_configuration {
#     name                          = module.spoke_azure_E3.vpc.private_subnets[0].name
#     subnet_id                     = module.spoke_azure_E3.vpc.private_subnets[0].subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_network_security_group" "e-spoke3-app" {
#   name                = "spoke3-app-east"
#   resource_group_name = module.spoke_azure_E4.vpc.resource_group
#   location            = var.azure-region-E1
# }

# resource "azurerm_network_security_rule" "e3-http" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "http"
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "80"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E3.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke3-app.name
# }

# resource "azurerm_network_security_rule" "e3-ssh" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "ssh"
#   priority                    = 110
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E3.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke3-app.name
# }

# resource "azurerm_network_security_rule" "e3-icmp" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "icmp"
#   priority                    = 120
#   protocol                    = "Icmp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E3.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke3-app.name
# }

# resource "azurerm_network_interface_security_group_association" "e3-main" {
#   network_interface_id      = azurerm_network_interface.e3-main.id
#   network_security_group_id = azurerm_network_security_group.e-spoke3-app.id
# }



# resource "azurerm_linux_virtual_machine" "azure_e3-spoke1_vm" {
#   name                            = "${var.azure_spk1_e3_name}-app"
#   resource_group_name             = var.rg
#   location                        = var.azure-region-E1
#   size                            = var.azure_vm_instance
#   admin_username                  = "ubuntu"
#   admin_password                  = var.az_linux_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.e3-main.id,
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

#   custom_data = base64encode(local.app_user_data)


# }


##########################################################################
##########################################################################
##VM EAST4
##########################################################################
##########################################################################

# resource "azurerm_network_interface" "e4-main" {
#   name                = "${var.azure_spk1_e4_name}-nic1"
#   resource_group_name = module.spoke_azure_E4.vpc.resource_group
#   location            = var.azure-region-E1
#   ip_configuration {
#     name                          = module.spoke_azure_E4.vpc.private_subnets[0].name
#     subnet_id                     = module.spoke_azure_E4.vpc.private_subnets[0].subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_network_security_group" "e-spoke4-app" {
#   name                = "spoke4-app-east"
#   resource_group_name = module.spoke_azure_E4.vpc.resource_group
#   location            = var.azure-region-E1
# }

# resource "azurerm_network_security_rule" "e4-http" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "http"
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "80"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E4.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke4-app.name
# }

# resource "azurerm_network_security_rule" "e4-ssh" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "ssh"
#   priority                    = 110
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E4.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke4-app.name
# }

# resource "azurerm_network_security_rule" "e4-icmp" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "icmp"
#   priority                    = 120
#   protocol                    = "Icmp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_E4.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.e-spoke4-app.name
# }

# resource "azurerm_network_interface_security_group_association" "e4-main" {
#   network_interface_id      = azurerm_network_interface.e4-main.id
#   network_security_group_id = azurerm_network_security_group.e-spoke4-app.id
# }



# resource "azurerm_linux_virtual_machine" "azure_e4-spoke1_vm" {
#   name                            = "${var.azure_spk1_e4_name}-app"
#   resource_group_name             = var.rg
#   location                        = var.azure-region-E1
#   size                            = var.azure_vm_instance
#   admin_username                  = "ubuntu"
#   admin_password                  = var.az_linux_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.e4-main.id,
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

#   custom_data = base64encode(local.app_user_data)


# }



##########################################################################
##########################################################################
##Native_VNETS
##########################################################################
##########################################################################

# resource "aviatrix_vpc" "azure_vnet_east1" {
#   cloud_type           = 8
#   account_name         = var.azureaccount
#   region               = var.azure-region-E1
#   name                 = "AZ-VNET-e1-native"
#   cidr                 = var.azure_nativeE1_cidr
#   resource_group       = var.rg
#   aviatrix_firenet_vpc = false
# }

# resource "aviatrix_vpc" "azure_vnet_east2" {
#   cloud_type           = 8
#   account_name         = var.azureaccount
#   region               = var.azure-region-E1
#   name                 = "AZ-VNET-e2-native"
#   cidr                 = var.azure_nativeE2_cidr
#   resource_group       = var.rg
#   aviatrix_firenet_vpc = false
# }


# ##
# ##Native_VMS
# ##

# resource "azurerm_public_ip" "app1-east" {
#   name                = "app1-east-pub_ip"
#   location            = var.azure-region-E1
#   resource_group_name = var.rg
#   allocation_method   = "Static"
# }

# resource "azurerm_network_interface" "app1-east" {
#   name                = "app1-east-nic"
#   location            = var.azure-region-E1
#   resource_group_name = var.rg

#   ip_configuration {
#     name                          = "app1-east-ip_conf"
#     subnet_id                     = aviatrix_vpc.azure_vnet_east1.public_subnets[1].subnet_id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.app1-east.id
#   }
# }


# resource "azurerm_network_security_group" "app1-east" {
#   name                = "app1-east"
#   resource_group_name = var.rg
#   location            = var.azure-region-E1
# }

# resource "azurerm_network_security_rule" "app1-http" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "http"
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "80"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg
#   network_security_group_name = azurerm_network_security_group.app1-east.name
# }

# resource "azurerm_network_security_rule" "app1-ssh" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "ssh"
#   priority                    = 110
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg
#   network_security_group_name = azurerm_network_security_group.app1-east.name

# }

# resource "azurerm_network_security_rule" "app1-icmp" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "icmp"
#   priority                    = 120
#   protocol                    = "Icmp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg
#   network_security_group_name = azurerm_network_security_group.app1-east.name
# }

# resource "azurerm_network_interface_security_group_association" "app1-east" {
#   network_interface_id      = azurerm_network_interface.app1-east.id
#   network_security_group_id = azurerm_network_security_group.app1-east.id
# }



# resource "azurerm_linux_virtual_machine" "app1-east-vm" {
#   name                            = "app1-east-vm"
#   resource_group_name             = var.rg
#   location                        = var.azure-region-E1
#   size                            = var.azure_vm_large_instance
#   admin_username                  = "ubuntu"
#   admin_password                  = var.az_linux_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.app1-east.id,
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }
#   custom_data = base64encode(local.app_user_data)


# }


# resource "azurerm_public_ip" "app2-east" {
#   name                = "app2-east-pub_ip"
#   location            = var.azure-region-E1
#   resource_group_name = var.rg
#   allocation_method   = "Static"
# }

# resource "azurerm_network_interface" "app2-east" {
#   name                = "app2-east-nic"
#   location            = var.azure-region-E1
#   resource_group_name = var.rg

#   ip_configuration {
#     name                          = "app2-east-ip_conf"
#     subnet_id                     = aviatrix_vpc.azure_vnet_east2.public_subnets[1].subnet_id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.app2-east.id
#   }
# }


# resource "azurerm_network_security_group" "app2-east" {
#   name                = "app2-east"
#   resource_group_name = var.rg
#   location            = var.azure-region-E1
# }

# resource "azurerm_network_security_rule" "app2-http" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "http"
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "80"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg
#   network_security_group_name = azurerm_network_security_group.app2-east.name
# }

# resource "azurerm_network_security_rule" "app2-ssh" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "ssh"
#   priority                    = 110
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg
#   network_security_group_name = azurerm_network_security_group.app2-east.name

# }

# resource "azurerm_network_security_rule" "app2-icmp" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "icmp"
#   priority                    = 120
#   protocol                    = "Icmp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg
#   network_security_group_name = azurerm_network_security_group.app2-east.name
# }

# resource "azurerm_network_interface_security_group_association" "app2-east" {
#   network_interface_id      = azurerm_network_interface.app2-east.id
#   network_security_group_id = azurerm_network_security_group.app2-east.id
# }



# resource "azurerm_linux_virtual_machine" "app2-east-vm" {
#   name                            = "app2-east-vm"
#   resource_group_name             = var.rg
#   location                        = var.azure-region-E1
#   size                            = var.azure_vm_instance
#   admin_username                  = "ubuntu"
#   admin_password                  = var.az_linux_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.app2-east.id,
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }
#   custom_data = base64encode(local.app_user_data)
# }

##########################################################################
##########################################################################
# ### NATIVE VNET PEERING
##########################################################################
##########################################################################

# resource "aviatrix_azure_peer" "azure_peer_1" {
#   account_name1             = var.azureaccount
#   account_name2             = var.azureaccount
#   vnet_name_resource_group1 = aviatrix_vpc.azure_vnet_east1.vpc_id
#   vnet_name_resource_group2 = aviatrix_vpc.azure_vnet_east2.vpc_id
#   vnet_reg1                 = aviatrix_vpc.azure_vnet_east1.region
#   vnet_reg2                 = aviatrix_vpc.azure_vnet_east2.region

# }

# resource "aviatrix_azure_peer" "AZ-peer-Transit" {
#   account_name1             = var.azureaccount
#   account_name2             = var.azureaccount
#   vnet_name_resource_group1 = aviatrix_vpc.azure_vnet_east1.vpc_id
#   vnet_name_resource_group2 = module.azure_transit_E1.vpc.vpc_id
#   vnet_reg1                 = aviatrix_vpc.azure_vnet_east1.region
#   vnet_reg2                 = module.azure_transit_E1.vpc.region

# }

##########################################################################
##########################################################################
######VM1-C1##
##########################################################################
##########################################################################


# resource "azurerm_network_interface" "main" {
#   name                = "${var.azure_spk1_c1_name}-nic1"
#   resource_group_name = module.spoke_azure_C1.vpc.resource_group
#   location            = var.azure-region-C1
#   ip_configuration {
#     name                          = module.spoke_azure_C1.vpc.private_subnets[0].name
#     subnet_id                     = module.spoke_azure_C1.vpc.private_subnets[0].subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_network_security_group" "spoke1-app" {
#   name                = "spoke1-app"
#   resource_group_name = module.spoke_azure_C1.vpc.resource_group
#   location            = var.azure-region-C1
# }

# resource "azurerm_network_security_rule" "http" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "http"
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "80"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_C1.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.spoke1-app.name
# }

# resource "azurerm_network_security_rule" "ssh" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "ssh"
#   priority                    = 110
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_C1.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.spoke1-app.name
# }

# resource "azurerm_network_security_rule" "icmp" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "icmp"
#   priority                    = 120
#   protocol                    = "Icmp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_C1.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.spoke1-app.name
# }

# resource "azurerm_network_interface_security_group_association" "main" {
#   network_interface_id      = azurerm_network_interface.main.id
#   network_security_group_id = azurerm_network_security_group.spoke1-app.id
# }



# resource "azurerm_linux_virtual_machine" "azure_spoke1_vm" {
#   name                            = "${var.azure_spk1_c1_name}-app"
#   resource_group_name             = var.rg
#   location                        = var.azure-region-C1
#   size                            = var.azure_vm_instance
#   admin_username                  = "ubuntu"
#   admin_password                  = var.az_linux_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.main.id,
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

#   custom_data = base64encode(local.app_user_data)



# }

##########################################################################
##########################################################################
#####VM1-C2
##########################################################################
##########################################################################


# resource "azurerm_network_interface" "c3-main" {
#   name                = "${var.azure_spk1_c3_name}-nic1"
#   resource_group_name = module.spoke_azure_C3.vpc.resource_group
#   location            = var.azure-region-C1
#   ip_configuration {
#     name                          = module.spoke_azure_C3.vpc.private_subnets[0].name
#     subnet_id                     = module.spoke_azure_C3.vpc.private_subnets[0].subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_network_security_group" "spoke3-app" {
#   name                = "spoke3-app"
#   resource_group_name = module.spoke_azure_C3.vpc.resource_group
#   location            = var.azure-region-C1
# }

# resource "azurerm_network_security_rule" "c-http" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "http"
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "80"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_C3.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.spoke1-app.name
# }

# resource "azurerm_network_security_rule" "c-ssh" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "ssh"
#   priority                    = 110
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_C3.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.spoke1-app.name
# }

# resource "azurerm_network_security_rule" "c-icmp" {
#   access                      = "Allow"
#   direction                   = "Inbound"
#   name                        = "icmp"
#   priority                    = 120
#   protocol                    = "Icmp"
#   source_port_range           = "*"
#   source_address_prefix       = "*"
#   destination_port_range      = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = module.spoke_azure_C3.vpc.resource_group
#   network_security_group_name = azurerm_network_security_group.spoke1-app.name
# }

# resource "azurerm_network_interface_security_group_association" "c3-main" {
#   network_interface_id      = azurerm_network_interface.c3-main.id
#   network_security_group_id = azurerm_network_security_group.spoke1-app.id
# }



# resource "azurerm_linux_virtual_machine" "azure_spoke3_vm" {
#   name                            = "${var.azure_spk1_c3_name}-app"
#   resource_group_name             = var.rg
#   location                        = var.azure-region-C1
#   size                            = var.azure_vm_instance
#   admin_username                  = "ubuntu"
#   admin_password                  = var.az_linux_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.c3-main.id,
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

#   custom_data = base64encode(local.app_user_data)



# }


