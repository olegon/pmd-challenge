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

variable "aws_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "pmd_log_group_name" {
  type    = string
  default = "ecs-awslogs-flosunhub-apex-pmd"
}

variable "nginx_proxy_container_image" {
  type    = string
  default = "olegon/nginx-pmd-proxy:0.0.1"
}

variable "apex_pmd_container_image" {
  type    = string
  default = "flosumhub/apex-pmd"
}

variable "apex_pmd_container_image_version" {
  type    = string
  default = "2.7.0"
}
