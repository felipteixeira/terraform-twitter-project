/*==========================
    **  Serviço twitter-app  **
        ===========================*/

module "cliente_pag_service" {
  source = "./modules/ecs-ec2"

  #Service settings
  environment      = local.domain
  service_name     = "twitter-app"
  container_name   = "twitter-app"
  service_port     = "3000"
  container_cpu    = "256"
  container_memory = "512"
  desired_count    = 1
  cluster_name     = module.ecs_twitter_app.cluster_name

  #Healthy settings
  target_group_protocol = "TCP"
  tcp_listener_port     = "8080"
  tcp_nlb_arn           = module.nlb_prod.nlb_arn
  healthy_threshold     = "2"
  unhealthy_threshold   = "2"
  deregistration_delay  = "10"

  #Network settings
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
  security_group     = [aws_security_group.twitter-app_sg.id]
  ecs_execution_role = aws_iam_role.service_role.arn

  #Environment
  container_environment = []

  container_ulimits = []
}
