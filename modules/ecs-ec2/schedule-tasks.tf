data "null_data_source" "schedule_task_info" {
  count = var.container_schedules != [] ? length(var.container_schedules) : 0

  inputs = {
    name    = var.container_schedules[count.index]["name"]
    cron    = var.container_schedules[count.index]["cron"]
    command = var.container_schedules[count.index]["command"]
  }
}

resource "aws_cloudwatch_event_rule" "schedule_event_rule" {
  count       = var.container_schedules != [] ? length(var.container_schedules) : 0
  name        = "schedule-event-${data.null_data_source.schedule_task_info[count.index].outputs["name"]}"
  description = "Evento agendado para o servico ${local.local_name}"

  schedule_expression = data.null_data_source.schedule_task_info[count.index].outputs["cron"]
  is_enabled          = true

  tags = {
    Name = "schedule-event-${data.null_data_source.schedule_task_info[count.index].outputs["name"]}"
  }
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = var.cluster_name
}

resource "aws_cloudwatch_event_target" "schedule_event_target" {
  count     = var.container_schedules != [] ? length(var.container_schedules) : 0
  target_id = "run-task-${data.null_data_source.schedule_task_info[count.index].outputs["name"]}"
  arn       = data.aws_ecs_cluster.cluster.arn
  rule      = aws_cloudwatch_event_rule.schedule_event_rule[count.index].name
  role_arn  = aws_iam_role.schedule_event_role[count.index].arn

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.container_td.arn

    dynamic "network_configuration" {
      for_each = var.environment == "dev" ? [] : [1]
      content {
        security_groups  = var.security_group
        subnets          = var.subnet_ids
        assign_public_ip = var.assign_public_ip
      }
    }
  }

  input = <<DOC
{
  "containerOverrides": [
    {
      "name": ${jsonencode(local.local_name)},
      "command": ${jsonencode(split(" ", data.null_data_source.schedule_task_info[count.index].outputs["command"]))}
    }
  ]
}
DOC
}

# #Permissions
resource "aws_iam_role" "schedule_event_role" {
  count = var.container_schedules != [] ? length(var.container_schedules) : 0
  name  = "ECS-ScheduleTask-${data.null_data_source.schedule_task_info[count.index].outputs["name"]}-Role"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

resource "aws_iam_role_policy" "schedule_event_policy" {
  count = var.container_schedules != [] ? length(var.container_schedules) : 0
  name  = "ECS-ScheduleTask-${data.null_data_source.schedule_task_info[count.index].outputs["name"]}-Policy"
  role  = aws_iam_role.schedule_event_role[count.index].id

  policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "iam:PassRole",
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "ecs:RunTask",
          "Resource": "*"
      }
  ]
}
DOC
}
