module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "apex-pmd-vpc"
  cidr = var.aws_vpc_cidr

  azs             = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  private_subnets = [cidrsubnet(var.aws_vpc_cidr, 8, 0), cidrsubnet(var.aws_vpc_cidr, 8, 1), cidrsubnet(var.aws_vpc_cidr, 8, 2)]
  public_subnets  = [cidrsubnet(var.aws_vpc_cidr, 8, 128), cidrsubnet(var.aws_vpc_cidr, 8, 129), cidrsubnet(var.aws_vpc_cidr, 8, 130)]

  single_nat_gateway = true # reducing costs!
  enable_nat_gateway = true # apps on private subnets needs internet access
}

resource "aws_security_group" "pmd_service" {
  name        = "pmd-service"
  description = "Allow PMD traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "nginx sidecar port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Why am I using [module.vpc.vpc_cidr_block] ?
    # NLB does not have SG, so I cant a trust a SG. (https://docs.aws.amazon.com/elasticloadbalancing/latest/network/target-group-register-targets.html#target-security-groups)
    # NLB needs to make healthchecks and there are ENIs on VPC, so Im trusting any communication within same VPC
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
