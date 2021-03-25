/*========================
    **    VPC Module   **
           ========================*/

data "aws_region" "current" {}

resource "aws_vpc_dhcp_options" "config_dhcp" {
  count               = var.enabled ? 1 : 0
  domain_name         = "${var.account_prefix}.local"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    Name     = "${var.account_prefix}-dhcp-principal"
    Ambiente = var.vpc_environment
  }
}

resource "aws_vpc" "vpc" {
  count                            = var.enabled ? 1 : 0
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name     = "${var.account_prefix}-vpc"
    Ambiente = var.vpc_environment
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  count           = var.enabled ? 1 : 0
  vpc_id          = element(aws_vpc.vpc.*.id, count.index)
  dhcp_options_id = element(aws_vpc_dhcp_options.config_dhcp.*.id, count.index)
}

#VPC endpoint's
resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  count           = var.enabled ? 1 : 0
  vpc_id          = element(aws_vpc.vpc.*.id, count.index)
  service_name    = "com.amazonaws.${var.vpc_region == "" ? data.aws_region.current.name : var.vpc_region}.s3"
  route_table_ids = [element(aws_route_table.private.*.id, count.index)]

  tags = {
    Name     = "${var.account_prefix}-vpc-endpoint-S3"
    Ambiente = var.vpc_environment
  }
}

resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_route" {
  count           = var.enabled ? 1 : 0
  route_table_id  = element(aws_route_table.private.*.id, count.index)
  vpc_endpoint_id = element(aws_vpc_endpoint.vpc_endpoint_s3.*.id, count.index)
}

#Internet Gateway
resource "aws_internet_gateway" "ig" {
  count  = var.enabled ? 1 : 0
  vpc_id = element(aws_vpc.vpc.*.id, count.index)

  tags = {
    Name     = "${var.account_prefix}-vpc-ig"
    Ambiente = var.vpc_environment
  }
}

#NAT Gateway with Elastic IP
resource "aws_eip" "nat_eip" {
  count      = var.enabled ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

resource "aws_nat_gateway" "nat" {
  count         = var.enabled ? 1 : 0
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = {
    Name     = "${var.account_prefix}-${element(var.availability_zones, 0)}-nat"
    Ambiente = var.vpc_environment
  }
}

#Public and Private subnets
resource "aws_subnet" "public_subnet" {
  count  = var.enabled ? length(var.availability_zones) : 0
  vpc_id = element(aws_vpc.vpc.*.id, count.index)

  cidr_block = var.pub_ipv4_subnets == null ? element([
    cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 0),
    cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 1),
    cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 2),
  ], count.index) : element(var.pub_ipv4_subnets, count.index)

  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name     = "${var.account_prefix}-${element(var.availability_zones, count.index)}-public-subnet-${lower(var.vpc_environment)}"
    Ambiente = var.vpc_environment
  }
}

resource "aws_subnet" "private_subnet" {
  count  = var.enabled ? length(var.availability_zones) : 0
  vpc_id = element(aws_vpc.vpc.*.id, count.index)
  cidr_block = var.priv_ipv4_subnets == null ? element([
    cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 3),
    cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 4),
    cidrsubnet(element(aws_vpc.vpc.*.cidr_block, count.index), var.subnet_newbits, 5),
  ], count.index) : element(var.priv_ipv4_subnets, count.index)

  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name     = "${var.account_prefix}-${element(var.availability_zones, count.index)}-private-subnet-${lower(var.vpc_environment)}"
    Ambiente = var.vpc_environment
  }
}

#Public and Private route tables
resource "aws_route_table" "public" {
  count  = var.enabled ? 1 : 0
  vpc_id = element(aws_vpc.vpc.*.id, count.index)

  tags = {
    Name     = "${var.account_prefix}-public-route-table"
    Ambiente = var.vpc_environment
  }
}

resource "aws_route_table" "private" {
  count  = var.enabled ? 1 : 0
  vpc_id = element(aws_vpc.vpc.*.id, count.index)

  tags = {
    Name     = "${var.account_prefix}-private-route-table"
    Ambiente = var.vpc_environment
  }
}

#Public and Private routes
resource "aws_route" "public_internet_gateway" {
  count                  = var.enabled ? 1 : 0
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig[count.index].id
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.enabled ? 1 : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
}

resource "aws_route" "private_interno_extra" {
  count                  = var.enabled && var.extra_route ? 1 : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = var.extra_address
  network_interface_id   = var.extra_interface
}

#Route table associations
resource "aws_route_table_association" "public" {
  count          = var.enabled ? length(aws_subnet.public_subnet.*.id) : 0
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = var.enabled ? length(aws_subnet.private_subnet.*.id) : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
