resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

resource aws_lb ecs {
  name               = "ecs-${var.name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.allow_all.id]
  idle_timeout       = 400
  tags = {
    Name = "ecs-${var.name}"
  }
}


resource aws_lb_listener "ecs_http_redirect" {
  load_balancer_arn = aws_lb.ecs.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs_default_http.arn
  }
}

# Generate a random string to add it to the name of the Target Group
resource random_string "alb_prefix_alb" {
  length  = 4
  upper   = false
  special = false
}

resource aws_alb_target_group "ecs_default_http" {
  name     = substr("ecs-${var.name}-default-http-${random_string.alb_prefix_alb.result}", 0, 32)
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}
