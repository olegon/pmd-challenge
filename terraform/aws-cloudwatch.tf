resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name              = "/aws/ecs/ecs-fargate"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "pmd" {
  name              = var.pmd_log_group_name
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "api-gw"
  retention_in_days = 7
}
