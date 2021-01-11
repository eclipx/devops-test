resource "aws_lb_listener_rule" "green" {
  listener_arn = aws_lb_listener.ecs_http_redirect.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    path_pattern {
      values = list(var.path)
    }
  }

  lifecycle {
    ignore_changes = [
      action[0].target_group_arn
    ]
  }

  priority = var.alb_priority != 0 ? var.alb_priority : null
}


# Generate a random string to add it to the name of the Target Group
resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource aws_lb_target_group "green" {
  name                 = var.compat_keep_target_group_naming ? "${var.cluster_name}-${var.name}-gr" : substr("${var.cluster_name}-${var.name}-gr-${random_string.alb_prefix.result}", 0, 32)
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10
  target_type          = var.launch_type == "FARGATE" ? "ip" : "instance"

  health_check {
    path                = var.healthcheck_path
    interval            = var.healthcheck_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    matcher             = var.healthcheck_matcher
  }

  lifecycle {
    create_before_destroy = true
  }
}