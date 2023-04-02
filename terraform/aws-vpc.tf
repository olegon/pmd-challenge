module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "apex-pmd-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  single_nat_gateway = true # reducing costs!

  enable_nat_gateway = true
}

resource "aws_security_group" "pmd" {
  name        = "pmd"
  description = "Allow PMD traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Application port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Why am I using [module.vpc.vpc_cidr_block] ?
    # NLB does not have SG, so I cant trust any SG. (https://docs.aws.amazon.com/elasticloadbalancing/latest/network/target-group-register-targets.html#target-security-groups)
    # NLB has to make healthchecks and there are ENIs on VPC
    cidr_blocks      = [module.vpc.vpc_cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
