#Launch configuration ARN
output "lc_arn" {
  value = aws_launch_configuration.launch_configuration.arn
}

#Autoscaling group ARN
output "asg_arn" {
  value = aws_autoscaling_group.autoscaling_group.arn
}
