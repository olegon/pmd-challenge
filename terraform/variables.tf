variable "app_username" {
  type    = string
  default = "og"
}

variable "app_password" {
  type    = string
  default = "42"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "pmd_log_group_name" {
  type    = string
  default = "ecs-awslogs-flosunhub-apex-pmd"
}

variable "nginx_proxy_container_image" {
  type    = string
  default = "olegon/nginx-pmd-proxy:latest"
}

variable "apex_pmd_container_image" {
  type    = string
  default = "flosumhub/apex-pmd:2.5.0"
}
