/*========================
    **    ECS EC2 MODULE   **
           ========================*/

resource "aws_ecs_service" "ecs_service" {
  name  = var.service_name
  task_definition = "${aws_ecs_task_definition.container_td.family}:${max(aws_ecs_task_definition.container_td.revision, data.aws_ecs_task_definition.container_td.revision)}"
  cluster        = local.cluster_name
  desired_count  = var.desired_count
	launch_type		 = var.launch_type != null ? var.launch_type :null	

  health_check_grace_period_seconds  = var.enable_alb == true ? var.healthcheck_grace_period : null
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  lifecycle {
    ignore_changes = [desired_count]
  }

  dynamic "load_balancer" {
    for_each = var.enable_alb == true ? [1] : []
    content{
      target_group_arn = aws_alb_target_group.tg_service[0].arn
      container_name   = local.local_name
      container_port   = var.service_port
    }
  }

  dynamic "load_balancer" {
    for_each = var.extra_target_groups == [] ? [] : var.extra_target_groups
    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.enable_cp == false ? [] : [1]
    content {
      capacity_provider = "${var.cluster_name}_cp"
      weight            = var.capacity_provider_strategies[0]["weight"]
      base              = var.capacity_provider_strategies[0]["base"]
    }
  }

  dynamic "network_configuration" {
    for_each = (var.environment == "dev" || var.target_group_protocol == "TCP") ? [] : [1]
    content {
      security_groups  = var.security_group
      subnets          = var.subnet_ids
      assign_public_ip = var.assign_public_ip
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = (var.imported == true && var.environment == "prod") ? [element(var.ordered_placement_strategy, 0)] : []  
    content {
      field = var.ordered_placement_strategy[0]["field"]
      type  = var.ordered_placement_strategy[0]["type"]
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = (var.imported == true && var.environment == "prod") ? [element(var.ordered_placement_strategy, 1)] : [] 
    content {
      field = var.ordered_placement_strategy[1]["field"]
      type  = var.ordered_placement_strategy[1]["type"]
    }
  }

  depends_on = [
    aws_ecr_repository.ecr_service,
    aws_alb_target_group.tg_service,
  ]
}