resource "aws_alb_target_group" "tg_service" {
  count       = var.enable_alb == true ? 1 : 0
	name     		= var.target_group_name == "" ? "tg-${var.service_name}" : var.target_group_name
	port     		= var.target_group_protocol != "TCP" ? local.target_port : var.tcp_listener_port
	protocol 		= var.target_group_protocol
	vpc_id      = var.vpc_id
	target_type = local.target_type
  deregistration_delay = var.deregistration_delay

	health_check {
		interval 						= var.healthcheck_interval
		healthy_threshold   = var.target_group_protocol == "TCP" ? var.unhealthy_threshold : var.healthy_threshold
		unhealthy_threshold = var.unhealthy_threshold
		timeout  						= var.target_group_protocol == "TCP" ? null : var.healthcheck_timeout
		matcher 						= var.target_group_protocol == "TCP" ? null : var.healthcheck_matcher
		path    						= var.target_group_protocol == "TCP" ? null : var.healthcheck_path
		port                = var.target_group_protocol == "TCP" ? null : var.healthcheck_port
		protocol            = var.target_group_protocol == "TCP" ? var.target_group_protocol : var.healthcheck_protocol
	}

  dynamic "stickiness" {
    for_each = var.target_group_protocol == "TCP" ? [] : [1]
    content {
      type    = "lb_cookie"
      enabled = false
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_http" {
  count        = (var.target_group_protocol != "TCP" && var.enable_alb == true) ? 1 : 0
  listener_arn = var.target_group_protocol != "TCP" ? var.alb_listener_arn : null

  condition {
    path_pattern {
      values = [var.context_path]
    }
  }

  dynamic "action" {
    for_each = var.rewrite_https == true ? [] : [1]
    content {
      type             = "forward"
      target_group_arn = aws_alb_target_group.tg_service[count.index].arn
    }
  }

  dynamic "action" {
    for_each = var.rewrite_https == false ? [] : [1]
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_302"
      }
    }
  }

  depends_on = [aws_alb_target_group.tg_service]
}

resource "aws_alb_listener_rule" "alb_extra_listener_rule_http" {
  count        = (var.target_group_protocol != "TCP" && var.alb_extra_rules != []) ? length(var.alb_extra_rules) : 0
  listener_arn = var.target_group_protocol != "TCP" ? var.alb_listener_arn : null

  condition {
    path_pattern {
      values = [var.alb_extra_rules[count.index]]
    }
  }

  dynamic "action" {
    for_each = var.rewrite_https == true ? [] : [1]
    content {
      type             = "forward"
      target_group_arn = aws_alb_target_group.tg_service[0].arn
    }
  }

  dynamic "action" {
    for_each = var.rewrite_https == false ? [] : [1]
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_302"
      }
    }
  }

  depends_on = [aws_alb_target_group.tg_service]
}

#TCP Settings
resource "aws_lb_listener" "alb_listener_tcp" {
  count             = (var.target_group_protocol == "TCP" && var.enable_alb == true) ? 1 : 0
  load_balancer_arn = var.tcp_nlb_arn
  port              = var.tcp_listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_service[count.index].arn
  }
}

