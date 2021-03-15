#ECS Cluster Vars.
variable "cluster_name" {
  description = "The cluster_name"
}


#Cluster Capacity Provider Vars.
variable "capacity_provider" {
  description = "The capacity_provider"
  default     = false
}

variable "capacity_provider_strategy" {
  description = "The capacity_provider_strategy"
  type        = list(any)
  default = [
    {
      weight = 1,
      base   = 0
    }
  ]
}

variable "autoscaling_group" {
  default = null
}

variable "managed_termination_protection" {
  description = "The managed_termination_protection"
  default     = "ENABLED"
}

variable "max_scaling_step_size" {
  description = "The maximum_scaling_step_size"
  default     = ""
}

variable "min_scaling_step_size" {
  description = "The minimum_scaling_step_size"
  default     = ""
}

variable "status" {
  description = "The status"
  default     = "ENABLED"
}

variable "target_capacity" {
  description = "The target_capacity"
  default     = 100
}

variable "weight" {
  description = "The weight"
  default     = 1
}

variable "base" {
  description = "The base"
  default     = 0
}


#Autoscaling group
variable "instance_type" { default = "" }
variable "key_name" { default = "" }
variable "ami_id" { default = null }
variable "user_data" { default = "" }
variable "security_groups" { default = "" }
variable "iam_instance_profile" { default = "" }
variable "desired_capacity" { default = "" }
variable "min_instance" { default = 0 }
variable "max_instance" { default = "" }
variable "subnets_id" { default = [] }
variable "asg_name" { default = null }
variable "lc_name" { default = null }
variable "spot_price" { default = null }
variable "public_ip" { default = false }
