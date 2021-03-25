module "vpc" {
  source = "./modules/vpc"

  vpc_region      = data.aws_region.current.name
  account_prefix  = local.prefix
  vpc_environment = local.environment

  vpc_cidr           = local.workspace["vpc_cidr"]
}
