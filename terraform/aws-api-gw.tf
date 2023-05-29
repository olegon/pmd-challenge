resource "aws_api_gateway_vpc_link" "this" {
  name        = "apex-pmd"
  description = "ELB from apex-pmd challange"
  target_arns = [module.elb.lb_arn]
}

resource "aws_api_gateway_rest_api" "this" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "apex-pmd"
      version = "1.0"
    }
    paths = {
      "/" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            connectionType       = "VPC_LINK"
            connectionId         = aws_api_gateway_vpc_link.this.id
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "http://${module.elb.lb_dns_name}/"
          }
        }
      }
      "/apexPMD" = {
        post = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            connectionType       = "VPC_LINK"
            connectionId         = aws_api_gateway_vpc_link.this.id
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "http://${module.elb.lb_dns_name}/apexPMD"
          }
        }
      }
      "/oauth/token" = {
        post = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            connectionType       = "VPC_LINK"
            connectionId         = aws_api_gateway_vpc_link.this.id
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "http://${module.elb.lb_dns_name}/oauth/token"
          }
        }
      }
    }
  })

  name = "apex-pmd"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "latest" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "latest"
}
