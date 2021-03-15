module "nlb_prod" {
  source = "./modules/nlb"

  env      = local.environment
  name     = local.prefix

  nlb_name  = "nlb-prod"
  subnets  = [module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1]]

  nlb_arn = module.nlb_prod.nlb_arn
}