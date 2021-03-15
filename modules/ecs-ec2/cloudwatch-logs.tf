resource "aws_cloudwatch_log_group" "log_group_service" {
  name              = "/ecs/${local.local_name}"
  retention_in_days = var.retention_in_days
}
