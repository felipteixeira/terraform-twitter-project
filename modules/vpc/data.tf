data "null_data_source" "subnets_cidr" {
  count = var.enabled ? length(var.availability_zones) : 0

  inputs = {
    public_ipv4_subnets_cidr =  var.pub_ipv4_subnets == null ? element([
      cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 0),
      cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 1),
      cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 2)
    ], count.index) : element(var.pub_ipv4_subnets, count.index)
                                
    private_ipv4_subnets_cidr = var.priv_ipv4_subnets == null ? element([
      cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 0),
      cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 1),
      cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 2)
    ], count.index) : element(var.priv_ipv4_subnets, count.index)

    public_ipv6_subnets_cidr = element([
      cidrsubnet(element(aws_vpc.vpc.*.ipv6_cidr_block, count.index), 8, 0),
      cidrsubnet(element(aws_vpc.vpc.*.ipv6_cidr_block, count.index), 8, 4),
      cidrsubnet(element(aws_vpc.vpc.*.ipv6_cidr_block, count.index), 8, 8),
    ], count.index)

    private_ipv6_subnets_cidr = element([
      cidrsubnet(element(aws_vpc.vpc.*.ipv6_cidr_block, count.index), 8, 1),
      cidrsubnet(element(aws_vpc.vpc.*.ipv6_cidr_block, count.index), 8, 5),
      cidrsubnet(element(aws_vpc.vpc.*.ipv6_cidr_block, count.index), 8, 9),
    ], count.index)
  }
}

