variable "elb_logs_bucket_name" {
  type    = string
  default = "og-elb-logs"
}

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
  default = "sa-east-1"
}