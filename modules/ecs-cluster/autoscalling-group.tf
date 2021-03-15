module "autoscaling_group" {
  count  = var.autoscaling_group == null ? 1 : 0
  source = "../launch-configuration"

  #Instances launch configuration
  name            = var.lc_name != null ? var.lc_name : "lc-${var.cluster_name}"
  cluster_name    = var.cluster_name
  instance_type   = var.instance_type
  ami_id          = var.ami_id != null ? var.ami_id : null
  key_name        = var.key_name
  user_data       = var.user_data
  security_groups = var.security_groups
  spot_price      = var.spot_price != null ? var.spot_price : null
  iam_instance_profile = var.iam_instance_profile
  public_ip = var.public_ip

  #Instances autoscaling group
  asg_name         = var.asg_name != null ? var.asg_name : null
  desired_capacity = var.desired_capacity
  min_instance     = var.min_instance
  max_instance     = var.max_instance
  subnets_id       = var.subnets_id
}