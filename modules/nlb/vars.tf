variable "env" {}
variable "name" {}
variable "nlb_name" {}
variable "nlb_arn" {}
variable "subnets" {}

variable "internal" {
  default = false
}

variable "enable_deletion_protection" {
  default = false
}

variable "enable_cross_zone_load_balancing" {
  default = true
}
