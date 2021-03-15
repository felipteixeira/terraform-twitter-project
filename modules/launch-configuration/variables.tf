#Launch config Vars.
variable "name" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "security_groups" {}
variable "key_name" {}
variable "user_data" {}
variable "cluster_name" {}

variable "ami_id" {
  default = null
}

variable "spot_price" {
  default = null
}

variable "public_ip" {
  default = false
}

variable "ebs_root_block_device" {
  type    = list(any)
  default = [
    {
      volume_type = "standard",
      volume_size = 30,
    }
  ]
}


#Autoscaling group
variable "max_instance" {}
variable "min_instance" {}
variable "desired_capacity" {}
variable "subnets_id" {}

variable "asg_name" {
  default = null
}

variable "default_cooldown" {
  default = 180
}

variable "healthcheck_grace_period" {
  default = 20
}

variable "healthcheck_type" {
  default = "ELB"
}

variable "protected_scale_in" {
  default = true
}

variable "enabled_metrics" {
  default = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]
}

locals {
  default_tags =  {
    "Name"    = var.name
    "Managed" = "Managed by Terraform"
  }
  asg_tags = merge(
    local.default_tags,
  )
}