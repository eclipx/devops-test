resource aws_ecs_service "default" {
  depends_on = [ aws_lb_listener.ecs_http_redirect, aws_ecs_cluster.ecs ]
  name                               = var.name
  cluster                            = var.cluster_name
  task_definition                    = var.image != "" ? aws_ecs_task_definition.default[0].arn : var.task_definition_arn
  desired_count                      = var.service_desired_count
  launch_type                        = var.launch_type

  network_configuration {
    subnets         = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.allow_all.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [load_balancer, desired_count, task_definition]
  }
}