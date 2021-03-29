resource "aws_ecr_repository" "ecr_service" {
  count = var.ecr_url == "" ? 1 : 0
  name  = "ecr_${var.service_name}"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "ecr_custom_policy" {
  count      = var.ecr_custom_policy != "" ? 1 : 0
  repository = aws_ecr_repository.ecr_service[count.index].name
  policy     = var.ecr_custom_policy
}