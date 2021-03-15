#SSM Parameter Store Outputs.
output "arn" {
  value = aws_ssm_parameter.parameter.arn
}

output "name" {
  value = aws_ssm_parameter.parameter.name
}

output "description" {
  value = aws_ssm_parameter.parameter.description
}

output "type" {
  value = aws_ssm_parameter.parameter.type
}

output "value" {
  value = aws_ssm_parameter.parameter.value
}

output "version" {
  value = aws_ssm_parameter.parameter.version
}