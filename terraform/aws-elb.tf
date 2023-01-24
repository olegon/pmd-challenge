module "elb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "pmd-elb"

  load_balancer_type = "network"
  internal           = true

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  access_logs = {
    bucket = "${data.aws_caller_identity.current.account_id}-pmd-elb-bucket"
  }

  target_groups = [
    {
      name_prefix      = "nginx-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "ip"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]
}