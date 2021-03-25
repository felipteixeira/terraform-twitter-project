variable "enabled" {
  description = "The enabled"
  default     = true
}

variable "vpc_region" {
  description = "The vpc_region"
  default     = ""
}

variable "account_prefix" {
  description = "The account_prefix"
}

variable "vpc_environment" {
  description = "The vpc_environtment"
}

variable "vpc_cidr" {
  description = "The vpc_cidr"
}

variable "availability_zones" {
  description = "The availability_zones"
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "subnet_newbits" {
  description = "The subnet_newbits"
  default     = 8
}

variable "extra_route" {
  description = "The extra_route"
  default     = false
}

variable "extra_address" {
  description = "The extra_address"
  default     = ""
}

variable "extra_interface" {
  description = "The extra_interface"
  default     = ""
}

variable "pub_ipv4_subnets" {
  description = "The pub_ipv4_subnets"
  type        = list(any)
  default     = null
}

variable "priv_ipv4_subnets" {
  description = "The priv_ipv4_subnets"
  type        = list(any)
  default     = null
}
