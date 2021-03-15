resource "aws_launch_configuration" "launch_configuration" {
  name                 = var.name
  image_id             = var.ami_id != null ? var.ami_id : data.aws_ami.amzn2_filter_ami.id
  instance_type        = var.instance_type
  spot_price           = var.spot_price
  iam_instance_profile = var.iam_instance_profile
  security_groups      = var.security_groups
  key_name             = var.key_name
  user_data            = data.template_file.user_data.rendered

  dynamic "root_block_device" {
    for_each = [var.ebs_root_block_device]
    content {
      volume_size           = var.ebs_root_block_device[0]["volume_size"]
      delete_on_termination = try(
          var.ebs_root_block_device[0]["delete_on_termination"],
          true
      )
      volume_type           = try(
        var.ebs_root_block_device[0]["volume_type"],
        "standard"
      )
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ user_data ]
  }

  associate_public_ip_address = var.public_ip
}

data "template_file" "user_data" {
  template = var.user_data
  vars = {
    cluster_name = var.cluster_name
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = var.asg_name != null ? var.asg_name : "asg-${var.name}"
  max_size                  = var.max_instance
  min_size                  = var.min_instance
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnets_id
  default_cooldown          = var.default_cooldown
  health_check_grace_period = var.healthcheck_grace_period
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  health_check_type         = var.healthcheck_type
  protect_from_scale_in     = var.protected_scale_in
  enabled_metrics           = var.enabled_metrics

  dynamic "tag" {
    for_each = local.asg_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}