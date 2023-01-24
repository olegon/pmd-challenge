module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "pmd-api-gw"
  description   = "Exposes PMD"
  protocol_type = "HTTP"

  #   cors_configuration = {
  #     allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
  #     allow_methods = ["*"]
  #     allow_origins = ["*"]
  #   }

  # Custom domain
  #   domain_name                 = "terraform-aws-modules.modules.tf"
  #   domain_name_certificate_arn = "arn:aws:acm:eu-west-1:052235179155:certificate/2b3a7ed9-05e1-4f9e-952b-27744ba06da6"

  #   Access logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.api_gw.arn
  # docs about logging format: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-logging.html
  default_stage_access_log_format = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId"

  # Routes and integrations
  integrations = {
    # docs about proxy integrations: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-http.html
    # docs about private integrations: https://docs.aws.amazon.com/pt_br/apigateway/latest/developerguide/http-api-develop-integrations-private.html
    "GET /" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "nlb"
      integration_type   = "HTTP_PROXY"
      integration_method = "GET"
      integration_uri    = module.elb.http_tcp_listener_arns[0]
    }

    "GET /server/log" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "nlb"
      integration_type   = "HTTP_PROXY"
      integration_method = "GET"
      integration_uri    = module.elb.http_tcp_listener_arns[0]
    }

    "POST /apexPMD" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "nlb"
      integration_type   = "HTTP_PROXY"
      integration_method = "POST"
      integration_uri    = module.elb.http_tcp_listener_arns[0]
    }

    "POST /oauth/token" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "nlb"
      integration_type   = "HTTP_PROXY"
      integration_method = "POST"
      integration_uri    = module.elb.http_tcp_listener_arns[0]
    }
  }

  vpc_links = {
    nlb = {
      security_group_ids = [aws_security_group.vpc_link.id]
      subnet_ids         = module.vpc.private_subnets
    }
  }

  create_api_domain_name = false
  create_vpc_link        = true
}
