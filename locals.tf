
locals {
 
  #Workspace PROD
  prod = {
    prod = {
      region                = "us-east-1"
      vpc_cidr              = "10.5.0.0/16"
      availability_zones    = ["us-east-1a", "us-east-1b"]
      nomenclature          = ["stone", "PROD"]
    }
  }

  workspace  = local.prod[terraform.workspace]
}

#Tratamento de variáveis.
locals {
  vpc_cidr              = local.workspace["vpc_cidr"]
  prefix                = element(local.workspace["nomenclature"], 0)
  environment           = element(local.workspace["nomenclature"], 1)
  domain                = lower(local.environment)
  main_az               = element(local.workspace["availability_zones"], 0)

  account_region = "${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


