# 

variable "controller_ip" {
  type = string
  # default = ""

}

variable "controller_username" {
  default     = "admin"
  description = "username"
}

variable "controller_password" {
  type = string
  #default = ""


}


variable "azureaccount" {
  type = string

}

variable "subscription_id" {
  type = string

}

variable  "awsaccount" {
  type = string
}

# variable "gcpaccount" {
#   type = string

# }


#aws-regions
variable "aws-east1" {
    default = "us-east-1" 
}
variable "aws-east2" {
  default = "us-east-2"
}
variable "aws-west1" {
  default = "us-west-1"
}
variable "aws_west2" {
  default = "us-west-2"
}
variable "aws_eu_west1" {
  default = "eu-west-1"
}

###AWS - Networking###

variable "transit-east2-cidr" {
    default = "10.255.200.0/23" 
}

 variable "transit-east1-cidr" {
     default = "10.255.202.0/23"
 }

variable "transit-west1-cidr" {
     default = "10.255.210.0/23"
}


 #spoke gateway Cidr addresses 

 variable "spoke-east1-cidr" {
     default = "10.100.0.0/23"
  
 }
 variable "spoke-east2-cidr" {
     default = "10.101.2.0/23"
  
 } 
 
 variable "spoke-east3-cidr" {
     default = "10.102.4.0/23"
  
 }
#Spoke GW Cidr us-east2

 variable "spoke-use2a-cidr" {
     default = "10.110.0.0/23"
  
 }
 variable "spoke-use2b-cidr" {
     default = "10.111.2.0/23"
  
 } 
 
 variable "spoke-use2c-cidr" {
     default = "10.112.4.0/23"
  
 }





#################################
##### security ##################
#################################


variable "pan_image" {
  default = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"

}

variable "ftnt_image" {
  default = "Fortinet FortiGate Next-Generation Firewall"

}

variable "avtx-egress" {
  default = "Aviatrix FQDN Egress Filtering"


}


###BOOTSTRAP VARIBLES
### must be declared in terraform.tfvars or *.tfvars file 
variable "boostrap" {
  type = string

}
variable "storagekey" {
  type = string

}

variable "fs_folder" {
  type = string

}

variable "FW-Password" {
  type = string

}

#----------------------------------------------------#
############## Azure VARS ############################
#____________________________________________________#


#regions#

variable "azure-region-C1" {
  default = "Central US"

}

variable "azure-region-E1" {
  default = "East US"

}

variable "azure-region-E2" {
  default = "East US 2"

}

variable "azure-region-SC1" {
  default = "South Central US"

}

variable "azure-region-W2" {
  default = "West US 2"

}

#Azure Spokes#

variable "azure_spokeC1_cidr" {
  default = "172.16.10.0/23"
}

variable "azure_spokeC2_cidr" {
  default = "172.16.12.0/23"
}

variable "azure_spokeC3_cidr" {
  default = "172.16.14.0/23"
}

variable "azure_nativeE1_cidr" {
  default = "10.30.10.0/23"
}

variable "azure_nativeE2_cidr" {
  default = "10.30.12.0/23"
}

variable "azure_spokeE1_cidr" {
  default = "10.20.10.0/23"
}

variable "azure_spokeE2_cidr" {
  default = "10.20.12.0/23"
}

variable "azure_spokeE3_cidr" {
  default = "10.20.14.0/23"
}

variable "azure_spokeE4_cidr" {
  default = "10.20.16.0/23"
}

variable "azure_spokeE5_cidr" {
  default = "10.20.18.0/23"
}

variable "azure_spokeE6_cidr" {
  default = "10.20.18.0/23"
}

###############
#Azure transit#

variable "azure_transitC1_cidr" {
  default = "172.16.250.0/23"

}

variable "azure_transitE1_cidr" {
  default = "10.10.10.0/23"

}

variable "azure_transitE2_cidr" {
  default = "10.10.12.0/23"

}



variable "azure_spk1_c1_name" {
  default = "AZ-SPOKE-C1-01"

}
variable "azure_spk1_c2_name" {
  default = "AZ-SPOKE-C2-01"

}
variable "azure_spk1_c3_name" {
  default = "AZ-SPOKE-C3-01"

}
variable "azure_trst_c1_name" {
  default = "AZ-TRANSIT-C1-01"

}
###################################


variable "azure_trst_e1_name" {
  default = "AZ-TRANSIT-E1-01"

}

variable "azure_spk1_e1_name" {
  default = "AZ-SPOKE-E1-01"

}
variable "azure_spk1_e2_name" {
  default = "AZ-SPOKE-E2-01"

}
variable "azure_spk1_e3_name" {
  default = "AZ-SPOKE-E3-HPE-01"

}

variable "azure_spk1_e4_name" {
  default = "AZ-SPOKE-E4-HPE-01"

}

variable "azure_spk1_e5_name" {
  default = "AZ-SPOKE-E5-01"

}

variable "azure_spk1_e6_name" {
  default = "AZ-SPOKE-E6-01"

}

##Azure resource group##

variable "rg" {
  default = "jg-sentinel-23"

}



#VM_Variables%%$#

variable "az_linux_password" {
  type = string
}

variable "azure_vm_instance" {
  default = "Standard_B1ms"
}

variable "azure_vm_large_instance" {
  default = "Standard_D5_v2"
}

variable "hpe" {
  default = "c5n.4xlarge"
  
}



variable "use1-web1" {
    default = "ami-052c4c69d742a9b23"
  
}
variable "use1-key" {
  default = "CtlrKP"
  
}