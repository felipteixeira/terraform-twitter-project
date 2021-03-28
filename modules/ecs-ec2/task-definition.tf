data "aws_caller_identity" "current_account_id" {}
data "aws_region" "current_region" {}

data "null_data_source" "service_port_mappings" {
  count = length(
    compact(concat(var.container_extra_ports, [var.service_port])),
  )

  inputs = {
    containerPort = element(
      compact(concat(var.container_extra_ports, [var.service_port])),
      count.index,
    )

    hostPort = element(
      compact(concat(var.container_extra_ports, [var.service_port])),
      count.index,
    )
    protocol = "tcp"
  }
}

resource "aws_ecs_task_definition" "container_td" {
  family                   = local.local_name
  requires_compatibilities = ["EC2"]
  network_mode             = local.network_mode
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.ecs_execution_role
  task_role_arn            = var.ecs_execution_role

  container_definitions = <<CONTAINER
  [
    {
      "name": "${local.local_name}",
      "image": "${var.ecr_url == "" ? aws_ecr_repository.ecr_service[0].repository_url : var.ecr_url}",
      "networkMode": "${local.network_mode}",
      "portMappings": ${replace(
  jsonencode(data.null_data_source.service_port_mappings.*.outputs),
  "/\"([0-9]+\\.?[0-9]*)\"/",
  "$1",
)},
      "memory": ${var.container_memory},
      "cpu": ${var.container_cpu},
      "memoryReservation": ${var.container_memory},
      "essential": true,
      "mountPoints": ${jsonencode(var.container_mountpoints)},
      "ulimits": ${jsonencode(var.container_ulimits)},
      "entryPoint": ${jsonencode(var.container_entrypoint)},
      "command": ${jsonencode(var.container_command)},
      "environment": ${jsonencode(var.container_environment)},
      "healthCheck": {
        "command": [
          "CMD-SHELL",
          "${var.healthcheck_cmd}"
        ],
        "timeout": ${var.healthcheck_task_timeout != "" ? var.healthcheck_task_timeout : var.healthcheck_timeout},
        "interval": ${var.healthcheck_interval},
        "retries": ${var.healthcheck_retries},
        "startPeriod": ${var.healthcheck_startPeriod}
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${local.local_name}",
          "awslogs-region": "${var.region == "" ? data.aws_region.current_region.name : var.region}",
          "awslogs-stream-prefix": "${local.local_name}"
        }
      },
      "secrets": ${jsonencode(var.container_secrets)}
    }
  ]
  
CONTAINER

depends_on = [aws_alb_target_group.tg_service]
}

data "aws_ecs_task_definition" "container_td" {
  task_definition = aws_ecs_task_definition.container_td.family
  depends_on      = [aws_ecs_task_definition.container_td, aws_ecr_repository.ecr_service]
}
