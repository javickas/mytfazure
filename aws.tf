
# provider "aws" {
#     alias = "use2"
#     region = var.aws-east2
  
# }


#%%%%%%%%%%%%%%%%%%%%%%%%
# Security_Groups %%%%%%%
#------------------------

module "avx-use1-spk1-sg001" {
    source              = "terraform-aws-modules/security-group/aws"
    version             = ">= 2.42.0"
    name                = "AVX-SPK1R1-SG001"
    description         = "Security group for example usage with EC2 instance"
    vpc_id              = module.aws-spoke1-use1.vpc.vpc_id
    ingress_cidr_blocks = ["0.0.0.0/0"]
    ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]
    egress_rules        = ["all-all"]
    providers = {
      aws = aws.east
     }
  
 }

# module "avx-use1-spk2-sg001" {
#     source              = "terraform-aws-modules/security-group/aws"
#     version             = ">= 2.42.0"
#     name                = "AVX-SPK2R1-SG001"
#     description         = "Security group for example usage with EC2 instance"
#     vpc_id              = module.aws-spoke1-use1.vpc.vpc_id
#     ingress_cidr_blocks = ["0.0.0.0/0"]
#     ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]
#     egress_rules        = ["all-all"]
#     providers = {
#       aws = aws.east
#      }
  
#  }




##########################################################################
##########################################################################
#%% Instances use1 %%
##########################################################################
##########################################################################

module "use1-jump-host" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "~> 3.0"

    name = "use1-jump-01"

    ami                    = var.use1-web1
    instance_type          = "t2.micro"
    key_name               = var.use1-key
    monitoring             = true
    vpc_security_group_ids = [module.avx-use1-spk1-sg001.security_group_id]
    subnet_id              = module.aws-spoke1-use1.vpc.public_subnets[0].subnet_id
    associate_public_ip_address = true
    providers = {
      aws = aws.east
     }

    tags = {
      OS   = "Linux"

}
}

module "use1-prvspk1-01" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "~> 3.0"

    name = "use1-web-01"

    ami                    = var.use1-web1
    instance_type          = "c5n.4xlarge"
    key_name               = var.use1-key
    monitoring             = true
    vpc_security_group_ids = [module.avx-use1-spk1-sg001.security_group_id]
    subnet_id              = module.aws-spoke1-use1.vpc.private_subnets[0].subnet_id
    associate_public_ip_address = false
    providers = {
      aws = aws.east
     }

    tags = {
      OS   = "Linux"

}

}



#%%%%%%%%%%%%%%%%%%%%%%%%
# Security_Groups use2 %%
#------------------------

# module "avx-spk1-sg001" {
#     source              = "terraform-aws-modules/security-group/aws"
#     version             = ">= 2.42.0"
#     name                = "AVX-SPK1R2-SG001"
#     description         = "Security group for example usage with EC2 instance"
#     vpc_id              = module.aws-spoke1-use2.vpc.vpc_id
#     ingress_cidr_blocks = ["0.0.0.0/0"]
#     ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]
#     egress_rules        = ["all-all"]
#     providers = {
#       aws = aws.ohio
#      }
  
#  }

# module "avx-spk2-sg001" {
#     source              = "terraform-aws-modules/security-group/aws"
#     version             = ">= 2.42.0"
#     name                = "AVX-SPK2R2-SG001"
#     description         = "Security group for example usage with EC2 instance"
#     vpc_id              = module.aws-spoke2-use2.vpc.vpc_id
#     ingress_cidr_blocks = ["10.0.0.0/8"]
#     ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]
#     egress_rules        = ["all-all"]
#     providers = {
#       aws = aws.ohio
#      }
  
#  }


# #%%%%%%%%%%%%%%%%%%
# #%% Instances use2%
# #------------------

# module "use2_jump_host" {
#     source = "terraform-aws-modules/ec2-instance/aws"
#     version = "~> 3.0"

#     name = "use2-jump-01"

#     ami                    = var.use2-web1
#     instance_type          = "t2.micro"
#     key_name               = var.ohio-east-key
#     monitoring             = true
#     vpc_security_group_ids = [module.avx-spk1-sg001.security_group_id]
#     subnet_id              = module.aws-spoke1-use2.vpc.public_subnets[0].subnet_id
#     associate_public_ip_address = true
#     providers = {
#       aws = aws.ohio
#      }

#     tags = {
#       OS   = "Linux"

# }
# }

# module "use2_prvspk1-01" {
#     source = "terraform-aws-modules/ec2-instance/aws"
#     version = "~> 3.0"

#     name = "use2-web-01"

#     ami                    = var.use2-web1
#     instance_type          = "t2.micro"
#     key_name               = var.ohio-east-key
#     monitoring             = true
#     vpc_security_group_ids = [module.avx-spk1-sg001.security_group_id]
#     subnet_id              = module.aws-spoke1-use2.vpc.private_subnets[0].subnet_id
#     associate_public_ip_address = false
#     providers = {
#       aws = aws.ohio
#      }

#     tags = {
#       OS   = "Linux"

# }



# }





