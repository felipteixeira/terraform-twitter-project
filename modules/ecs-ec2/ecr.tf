resource "aws_ecr_repository" "ecr_service" {
  count = var.ecr_url == "" ? 1 : 0
  name  = "ecr_${var.service_name}"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# data "template_file" "ecr_lifecycle_policy" {
#   template = file("./policies/ecr-lifecycle-policy.json")

#   vars = {
#     count_unit   = var.ecr_lifecycle_unit
#     count_number = var.ecr_lifecycle_number
#   }
# }

# resource "aws_ecr_lifecycle_policy" "ecr_service_policy" {
#   repository = aws_ecr_repository.ecr_service.name
#   policy     = data.template_file.ecr_lifecycle_policy.rendered
# }

#Caso seja necessário adicionar um politica customizada
#Exemplo: Permitir outra conta fazer ações nesse repositório.
resource "aws_ecr_repository_policy" "ecr_custom_policy" {
  count      = var.ecr_custom_policy != "" ? 1 : 0
  repository = aws_ecr_repository.ecr_service[count.index].name
  policy     = var.ecr_custom_policy
}