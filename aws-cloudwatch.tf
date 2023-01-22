resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "api-gw"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "pmd" {
  name              = "ecs-awslog-flosunhub-apex-pmd"
  retention_in_days = 7
}
