output "api_gateway_endpoint" {
  value = aws_api_gateway_stage.latest.invoke_url
}




# # these outputs exist just to help you interect with the workload! :)

output "get_root_curl_command" {
  value = "curl -i '${aws_api_gateway_stage.latest.invoke_url}'"
}

output "get_server_log_curl_command" {
  value = "curl -i '${aws_api_gateway_stage.latest.invoke_url}/server/log'"
}

output "post_token_curl_command" {
  value = "curl -i -X POST '${aws_api_gateway_stage.latest.invoke_url}/oauth/token?username=admin&password=n2c99skEwmWvt3Q1p7d11ne4FKwPqCs85N2RvwNdlfMw4I3NL' -u '${var.app_username}:${var.app_password}'"
}

output "post_run_curl_command" {
  value = "curl -i -X POST '${aws_api_gateway_stage.latest.invoke_url}/apexPMD' -H 'Content-Type: application/json' -d '{ \"backUrl\": \"...salesforce uri...\", \"sId\": \"...salesforce token...\", \"jobId\": \"...unique job id...\", \"attList\": [], \"attRuls\": [], \"branchId\": \"\" }'"
}
