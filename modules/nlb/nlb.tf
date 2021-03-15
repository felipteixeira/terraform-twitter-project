resource "aws_lb" "network_load_balancer" {
  name               = var.nlb_name
  load_balancer_type = "network"

  internal = var.internal
  subnets  = var.subnets

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection

  tags = {
    Account     = var.name
    Environment = var.env
  }
}
