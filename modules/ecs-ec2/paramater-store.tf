module "ecr_param" {
  source = "../parameter-store"

  name        = "/codebuild/ecs/${local.local_name}/ecr"
  type        = "String"
  value       = var.ecr_url != "" ? var.ecr_url : aws_ecr_repository.ecr_service[0].repository_url 
  description = "Repositorio ECR de ${local.local_name}"
}

module "cluster_param" {
  source = "../parameter-store"

  name        = "/codebuild/ecs/${local.local_name}/cluster"
  type        = "String"
  value       = var.cluster_name
  description = "Servico no cluster ${var.cluster_name}"
}