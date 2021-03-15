#ECS Service outputs
output "service_name" {
  value = aws_ecs_service.ecs_service.name
}


#Task Definition outputs
output "task_arn" {
  value = aws_ecs_task_definition.container_td.arn
}

output "task_family" {
  value = aws_ecs_task_definition.container_td.family
}

output "task_revision" {
  value = aws_ecs_task_definition.container_td.revision
}


#ECR outputs
output "repository_url" {
  value = aws_ecr_repository.ecr_service.*.repository_url
}

output "ecr_arn" {
  value = aws_ecr_repository.ecr_service.*.arn
}

