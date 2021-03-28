output "nlb_arn" {
  value = aws_lb.network_load_balancer.arn
}

output "nlb_dns" {
  value = aws_lb.network_load_balancer.dns_name
}