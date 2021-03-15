#ECS SERVICE AutoScaling
resource "aws_appautoscaling_target" "autoscaling_service_target" {
  count              = var.tasks_scaling == true ? 1 : 0
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_tasks
  max_capacity       = var.max_tasks

  depends_on = [aws_ecs_service.ecs_service]

  lifecycle {
    ignore_changes = [min_capacity, max_capacity]
  }
}

resource "aws_appautoscaling_policy" "cpu_autoscaling_service_policy" {
  count              = var.tasks_scaling == true ? 1 : 0
  name               = format("ECS_%s", var.target_value)
  service_namespace  = aws_appautoscaling_target.autoscaling_service_target[count.index].service_namespace
  scalable_dimension = aws_appautoscaling_target.autoscaling_service_target[count.index].scalable_dimension
  resource_id        = aws_appautoscaling_target.autoscaling_service_target[count.index].resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.metric_type
    }

    target_value       = var.target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    disable_scale_in   = var.disable_scale_in
  }

  depends_on = [aws_appautoscaling_target.autoscaling_service_target]
}