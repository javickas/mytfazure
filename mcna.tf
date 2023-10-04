#########################################################
############## MCNA Azure build outs Central  ###########
#########################################################

# # module "azure_transit_C1" {
# #   source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
# #   version = "2.5.0"

# #   cloud                  = "azure"
# #   region                 = var.azure-region-C1
# #   cidr                   = var.azure_transitC1_cidr
# #   account                = var.azureaccount
# #   resource_group         = var.rg
# #   name                   = var.azure_trst_c1_name
# #   enable_transit_firenet = true

# # }

# # module "azure_firenet_1" {
# #   source  = "terraform-aviatrix-modules/mc-firenet/aviatrix"
# #   version = "v1.4.3"

# #   transit_module           = module.azure_transit_C1
# #   firewall_image           = var.pan_image
# #   firewall_image_version   = "9.1.0"
# #   username                 = "fwadmin"
# #   password                 = var.FW-Password
# #   bootstrap_storage_name_1 = var.boostrap
# #   storage_access_key_1     = var.storagekey
# #   file_share_folder_1      = var.fs_folder
# #   egress_enabled           = true

# # }

# # module "spoke_azure_C1" {
# #   source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
# #   version = "1.6.2"

# #   cloud          = "Azure"
# #   name           = var.azure_spk1_c1_name
# #   cidr           = var.azure_spokeC1_cidr
# #   region         = var.azure-region-C1
# #   account        = var.azureaccount
# #   resource_group = var.rg
# #   transit_gw     = module.azure_transit_C1.transit_gateway.gw_name # <<<--- Use object reference in stead of hardcoding the name
# # }

# # module "spoke_azure_C2" {
# #   source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
# #   version = "1.6.2"

# #   cloud          = "Azure"
# #   name           = var.azure_spk1_c2_name
# #   cidr           = var.azure_spokeC2_cidr
# #   region         = var.azure-region-C1
# #   account        = var.azureaccount
# #   resource_group = var.rg
# #   transit_gw     = module.azure_transit_C1.transit_gateway.gw_name # <<<--- Use object reference in stead of hardcoding the name
# # }

# # module "spoke_azure_C3" {
# #   source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
# #   version = "1.6.2"

# #   cloud          = "Azure"
# #   name           = var.azure_spk1_c3_name
# #   cidr           = var.azure_spokeC3_cidr
# #   region         = var.azure-region-C1
# #   account        = var.azureaccount
# #   resource_group = var.rg
# #   transit_gw     = module.azure_transit_C1.transit_gateway.gw_name # <<<--- Use object reference in stead of hardcoding the name
# }

##########################################################################
##########################################################################
#### East Region ########
##########################################################################
##########################################################################

module "azure_transit_E1" {
  source                 = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version                = "2.5.0"
  cloud                  = "azure"
  region                 = var.azure-region-E1
  cidr                   = var.azure_transitE1_cidr
  account                = var.azureaccount
  resource_group         = var.rg
  name                   = var.azure_trst_e1_name
  enable_transit_firenet = true
  insane_mode            = true
  instance_size          = "Standard_DS4_v2"
}

# module "azure_firenet_e1" {
#   source                   = "terraform-aviatrix-modules/mc-firenet/aviatrix"
#   version                  = "v1.4.3"
#   transit_module           = module.azure_transit_E1
#   firewall_image           = var.pan_image
#   firewall_image_version   = "9.1.0"
#   username                 = "fwadmin"
#   password                 = var.FW-Password
#   bootstrap_storage_name_1 = var.boostrap
#   storage_access_key_1     = var.storagekey
#   file_share_folder_1      = var.fs_folder
#   egress_enabled           = true
#  }

module "spoke_azure_E1" {
  source         = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version        = "1.6.2"
  cloud          = "Azure"
  name           = var.azure_spk1_e1_name
  cidr           = var.azure_spokeE1_cidr
  region         = var.azure-region-E1
  account        = var.azureaccount
  resource_group = var.rg
  insane_mode    = true  
  transit_gw     = module.azure_transit_E1.transit_gateway.gw_name # <<<--- Use object reference in stead of hardcoding the name
}

# module "spoke_azure_E2" {
#   source         = "terraform-aviatrix-modules/mc-spoke/aviatrix"
#   version        = "1.6.2"
#   cloud          = "Azure"
#   name           = var.azure_spk1_e2_name
#   cidr           = var.azure_spokeE2_cidr
#   region         = var.azure-region-E1
#   account        = var.azureaccount
#   resource_group = var.rg
#   transit_gw     = module.azure_transit_E1.transit_gateway.gw_name # <<<--- Use object reference in stead of hardcoding the name
# }

# module "spoke_azure_E3" {
#   source         = "terraform-aviatrix-modules/mc-spoke/aviatrix"
#   version        = "1.6.2"
#   cloud          = "Azure"
#   name           = var.azure_spk1_e3_name
#   cidr           = var.azure_spokeE3_cidr
#   region         = var.azure-region-E1
#   account        = var.azureaccount
#   resource_group = var.rg
#   transit_gw     = module.azure_transit_E1.transit_gateway.gw_name # <<<--- Use object reference in stead of hardcoding the name
#   insane_mode    = true
#   instance_size  = "Standard_B2ms"
# }

# module "spoke_azure_E4" {
#   source         = "terraform-aviatrix-modules/mc-spoke/aviatrix"
#   version        = "1.6.2"
#   cloud          = "Azure"
#   name           = var.azure_spk1_e4_name
#   cidr           = var.azure_spokeE4_cidr
#   region         = var.azure-region-E1
#   account        = var.azureaccount
#   resource_group = var.rg
#   transit_gw     = module.azure_transit_E1.transit_gateway.gw_name
#   insane_mode    = true
#   instance_size  = "Standard_B2ms"
# }

#########################################################
############## MCNA AWS Transit      ####################
#########################################################



module "mc_transit_use1" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.5.0"
  cloud   = "AWS"
  name    = "trnst-use1-01"
  region  = var.aws-east1
  cidr    = var.transit-east1-cidr
  account = var.awsaccount
  enable_transit_firenet = true
  insane_mode = true
  instance_size = var.hpe
  #firewall_image = var.pan_image
  #enable_transit_firenet = "true"
  #enable_egress_transit_firenet = "false"


}

#########################################################
############## MCNA AWS SPOKE      ######################
#########################################################

module "aws-spoke1-use1" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.6.2"

  cloud      = "AWS"
  name       = "spk1-use1-01"
  cidr       = var.spoke-east1-cidr
  region     = var.aws-east1
  account    = var.awsaccount
  insane_mode = true
  instance_size = var.hpe
  attached = true 
  transit_gw = module.mc_transit_use1.transit_gateway.gw_name
 



}







##########################################################################
##########################################################################
#### Transit Peering #########
##########################################################################
##########################################################################

# Create an Aviatrix Transit Gateway Peering


resource "aviatrix_transit_gateway_peering" "transit_gateway_peering_1" {
  transit_gateway_name1 = module.azure_transit_E1.transit_gateway.gw_name
  transit_gateway_name2 = module.mc_transit_use1.transit_gateway.gw_name
}
