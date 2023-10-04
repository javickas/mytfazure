#########################################################
############## Provider        ##########################
#########################################################

terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "~> 3.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.35.0"
    }
  }
}
provider "aviatrix" {
  controller_ip = var.controller_ip
  username      = var.controller_username
  password      = var.controller_password

}

provider "aws" {
  alias  = "east"
  region = var.aws-east1


}
provider "aws" {
  alias  = "ohio"
  region = var.aws-east2

}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
