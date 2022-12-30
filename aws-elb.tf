module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "pmd-alb"

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [
    aws_security_group.alb.id
  ]

  access_logs = {
    bucket = var.elb_logs_bucket_name
  }

  target_groups = [
    {
      name_prefix      = "pmd-"
      backend_protocol = "HTTP"
      backend_port     = 5000
      target_type      = "ip"
    }
  ]

  #   https_listeners = [
  #     {
  #       port               = 443
  #       protocol           = "HTTPS"
  #       certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #       target_group_index = 0
  #     }
  #   ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  depends_on = [
    module.s3_bucket_elb_logs
  ]
}