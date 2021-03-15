resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  capacity_providers = var.capacity_provider == true ? ["${var.cluster_name}_cp"] : null

  dynamic "default_capacity_provider_strategy" {
    for_each = var.capacity_provider == true ? [var.capacity_provider_strategy] : []
    content {
      capacity_provider = try(
          aws_ecs_capacity_provider.ecs_capacity_provider[0].name,
         "${var.cluster_name}_cp"
      ) 
      weight = var.capacity_provider_strategy[0]["weight"]
      base   = var.capacity_provider_strategy[0]["base"]
    }
  }
  
  depends_on = [aws_ecs_capacity_provider.ecs_capacity_provider]
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  count = var.capacity_provider == true ? 1 : 0
  name  = "${var.cluster_name}_cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.autoscaling_group ==  null ? module.autoscaling_group[0].asg_arn : var.autoscaling_group
    managed_termination_protection = var.managed_termination_protection

    managed_scaling {
      minimum_scaling_step_size = var.min_scaling_step_size
      maximum_scaling_step_size = var.max_scaling_step_size
      status                    = var.status
      target_capacity           = var.target_capacity
    }
  }
}