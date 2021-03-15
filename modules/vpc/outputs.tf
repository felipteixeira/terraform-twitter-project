output "vpc_cidr" {
  value = element(aws_vpc.vpc.*.cidr_block, 0)
}

output "vpc_id" {
  value = element(aws_vpc.vpc.*.id, 0)
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "public_route_table_id" {
  value = element(aws_route_table.public.*.id, 0)
}

output "private_route_table_id" {
  value = element(aws_route_table.private.*.id, 0)
}
