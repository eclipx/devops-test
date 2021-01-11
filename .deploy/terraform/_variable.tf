variable "name" {
  description = "Name of your ECS service"
  default = "test-service"
}

variable "container_port" {
  default     = "8080"
  description = "Port your container listens (used in the placeholder task definition)"
}

variable "port" {
  default     = "80"
  description = "Port for target group to listen"
}

variable "memory" {
  default     = "1024"
  description = "Hard memory of the container"
}

variable "cpu" {
  default     = "512"
  description = "Hard limit for CPU for the container"
}

variable "path" {
  default     = "/*"
  description = "Optional path to use on listener rule"
}

variable "alb" {
  default     = false
  description = "Whether to deploy an alb"
}

variable "healthcheck_path" {
  default = "/"
}

variable "healthcheck_interval" {
  default = "10"
}

variable "cluster_name" {
  default = "dev-cluster"
}

variable "service_desired_count" {
  default     = 1
  description = "Desired count for this service (for use when auto scaling is disabled)"
}

variable "image" {
  description = "Docker image to deploy (can be a placeholder)"
  default     = "learnawstechclub/hello-world-node:v1.0.0"
}

variable "cloudwatch_logs_retention" {
  default     = 120
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
}

variable "task_definition_arn" {
  description = "Task definition to use for this service (optional)"
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID to deploy this app to"
  default = "vpc-f2d5d795"
}

variable "alb_priority" {
  default     = 0
  description = "priority rules ALB"
}

variable "healthy_threshold" {
  default     = 3
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "unhealthy_threshold" {
  default     = 3
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "healthcheck_timeout" {
  default     = 5
  description = "The amount of time, in seconds, during which no response"
}

variable "healthcheck_matcher" {
  default     = 200
  description = "The HTTP codes to use when checking for a successful response from a target"
}

variable "launch_type" {
  default     = "FARGATE"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}

variable "compat_keep_target_group_naming" {
  default     = false
  description = "Keeps old naming convention for target groups to avoid recreation of resource in production environments"
}

variable "network_mode" {
  default     = null
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}