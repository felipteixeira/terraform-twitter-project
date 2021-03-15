#ECR Vars.
variable "ecr_lifecycle_unit" {
  description = "The ecr_lifecycle_unit"
  default     = "days"
}

variable "ecr_lifecycle_number" {
  description = "The ecr_lifecycle_number"
  default     = 7
}

variable "ecr_custom_policy" {
  description = "The ecr_custom_policy"
  default     = ""
}


#CloudWatch Log Vars.
variable "retention_in_days" {
  description = "The retention_in_days"
  default     = 7
}


#Service Discovery Vars.
variable "service_discovery_name" {
  description = "The service_discovery_name"
  default     = ""
}

variable "service_discovery_namespace" {
  description = "The service_discovery_namespace"
  default     = ""
}

variable "dns_ttl" {
  description = "The dns_ttl"
  default     = 10
}

variable "dns_srv" {
  description = "The dns_srv"
  default     = true
}

variable "dns_failure_threshold" {
  description = "The dns_failure_threshold"
  default     = 3
}

variable "dns_type" {
  description = "The dns_type"
  default     = "A"
}

variable "routing_policy" {
  description = "The routing_policy"
  default     = "MULTIVALUE"
}

variable "healthcheck_retries" {
  description = "The healthcheck_retries"
  default     = 3
}

variable "healthcheck_startPeriod" {
  description = "The healthcheck_startPeriod"
  default     = 10
}


#ECS Vars.
variable "environment" {
  description = "Define se o network mode será awsvpc ou bridge" 
}

variable "service_name" {
  description = "The service_name"
}

variable "container_name" {
  description = "The container_name"
  default     = null
}

variable "imported" {
  description = "Variavel utilizada somente em modulos importados para o state."
  default     = false
}

variable "cluster_name" {
  description = "The cluster_name"
}

variable "desired_count" {
  description = "The desired_count"
  default     = 1
}

variable "extra_target_groups" {
  description = "The extra_target_groups"
  type        = list(any)
  default     = []
}

variable "launch_type" {
  description = "The launch_type"
  default     = null
}

variable "enable_cp" {
  description = "The enable_cp"
  type        = bool
  default     = false
}

variable "capacity_provider_strategies" {
  type    = list(any)
  default = [
    {
      weight = 1
      base   = 0
    }
  ]
}

variable "healthcheck_grace_period" {
  description = "The healthcheck_grace_period"
  default     = 30
}

variable "deployment_maximum_percent" {
  description = "The deployment_maximum_percent"
  default     = "200"
}

variable "deployment_minimum_healthy_percent" {
  description = "The deployment_minimum_healthy_percent"
  default     = "100"
}

variable "security_group" {
  type        = list(string)
  description = "The security_group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet_ids"
}

variable "assign_public_ip" {
  description = "The assign_public_ip"
  default     = false
}

variable "ordered_placement_strategy" {
  type    = list(any)
  default = [
    {
      field = "attribute:ecs.availability-zone"
      type  = "spread"
    },
    {
      field = "instanceId"
      type  = "spread"
    }
  ]
}

#Task Definition Vars.
variable "region" {
  description = "The region"
  default     = ""
}

variable "container_cpu" {
  description = "The container_cpu"
}

variable "container_memory" {
  description = "The container_memory"
}

variable "ecs_execution_role" {
  description = "The ecs_eExecution_role"
}

variable "ecr_url" {
  description = "The ecr_url"
  default     = ""
}

variable "container_extra_ports" {
  description = "The container_extra_ports"
  default     = [""]
}

variable "container_mountpoints" {
  description = "The container_mountpoints"
  type        = list(any)
  default     = []
}

variable "container_ulimits" {
  description = "The container_ulimits"
  type        = list(any)
  default     = []
}

variable "container_entrypoint" {
  description = "The container_entrypoint"
  type        = list(string)
  default     = []
}

variable "container_command" {
  description = "The container_command"
  type        = list(string)
  default     = []
}

variable "container_environment" {
  description = "The container_environment"
  type        = list(any)
  default     = []
}

variable "container_secrets" {
  description = "The container_secrets"
  type        = list(any)
  default     = []
}

variable "healthcheck_cmd" {
  description = "The healthcheck_cmd"
  default     = "exit 0"
}


#Scaling Vars.
variable "tasks_scaling" {
  description = "The tasks_scaling"
  default     = false
}

variable "metric_type" {
  description = "The metric_type"
  default     = "ECSServiceAverageCPUUtilization"
}

variable "min_tasks" {
  description = "The min_tasks"
  default     = 1
}

variable "max_tasks" {
  description = "The max_tasks"
  default     = 10
}

variable "target_value" {
  description = "The target_value"
  default     = 50
}

variable "scale_in_cooldown" {
  description = "The scale_in_cooldown"
  default     = 120
}

variable "scale_out_cooldown" {
  description = "The scale_out_cooldown"
  default     = 200
}

variable "disable_scale_in" {
  description = "The disable_scale_in"
  default     = false
}


#ALB Vars.
variable "enable_alb"{
  default = true
}

variable "vpc_id" {
  description = "The vpc_id"
}

variable "service_port" {
  description = "The service_port"
}

variable "target_group_protocol" {
  description = "The target_group_protocol"
  default     = "HTTP"
}

variable "target_type" {
  description = "The target_type"
  default     = "ip"
}

variable "target_group_name" {
  description = "The target_group_name"
  default     = ""
}

variable "target_group_port" {
  description = "The target_group_port"
  default     = null
}

variable "healthcheck_interval" {
  description = "The healthcheck_interval"
  default     = "30"
}

variable "healthcheck_timeout" {
  description = "The healthcheck_timeout"
  default     = "15"
}

variable "healthcheck_task_timeout" {
  description = "The healthcheck_task_timeout"
  default     = ""
}

variable "healthy_threshold" {
  description = "The healthy_threshold"
  default     = "5"
}

variable "unhealthy_threshold" {
  description = "The unhealthy_threshold"
  default     = "2"
}

variable "healthcheck_matcher" {
  description = "The healthcheck_matcher"
  default     = "200"
}

variable "healthcheck_path" {
  description = "The healthcheck_path"
  default     = "/"
}

variable "rewrite_https" {
  description = "The rewrite_https"
  default     = false
}

variable "healthcheck_port" {
  description = "The healthcheck_port"
  default     = "traffic-port"
}

variable "healthcheck_protocol" {
  description = "The healthcheck_protocol"
  default     = "HTTP"
}

variable "alb_listener_arn" {
  description = "The alb_listener_arn"
  default     = ""
}

variable "context_path" {
  description = "The context_path"
  default     = "/"
}

variable "alb_extra_rules" {
  description = "The alb_extra_rules"
  default     = []
}

variable "deregistration_delay" {
  description = "The deregistration_delay"
  default     = 300
}


#TCP NLB Vars.
variable "tcp_nlb_arn" {
  description = "The tcp_nlb_arn"
  default     = "" 
}

variable "tcp_listener_port" {
  description = "The tcp_listener_port"
  default     = "" 
}

#Schedule Vars.
variable "container_schedules" {
  description = "The container_schedules"
  type        = list(any)
  default     = []
}


locals {
  local_name   = (var.container_name != null ? var.container_name : var.service_name)
  target_type  = (var.environment == "dev" || var.target_group_protocol == "TCP") ? "instance" : "ip"
  network_mode = (var.environment == "dev" || var.target_group_protocol == "TCP") ? "bridge" : "awsvpc"
  cluster_name = var.imported == true ? "arn:aws:ecs:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account_id.account_id}:cluster/${var.cluster_name}" : var.cluster_name
  target_port  = (var.target_group_port != null ? var.target_group_port : var.service_port)
}