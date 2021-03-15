module "vpc" {
  source = "./modules/vpc"

  vpc_region      = data.aws_region.current.name
  account_prefix  = local.prefix
  vpc_environment = local.environment

  vpc_cidr           = local.workspace["vpc_cidr"]
  availability_zones = local.workspace["availability_zones"]

  pub_ipv4_subnets  = local.workspace["public_subnets_cidr"]
  priv_ipv4_subnets = local.workspace["private_subnets_cidr"]
}
