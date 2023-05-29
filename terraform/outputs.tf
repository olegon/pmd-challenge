output "api_gateway_endpoint" {
  value = aws_api_gateway_stage.latest.invoke_url
}




# # these outputs exist just to help you interect with the workload! :)

output "get_root_curl_command" {
  value = "curl -i '${aws_api_gateway_stage.latest.invoke_url}'"
}

output "post_token_curl_command" {
  value = "curl -i -X POST '${aws_api_gateway_stage.latest.invoke_url}/oauth/token?username=admin&password=n2c99skEwmWvt3Q1p7d11ne4FKwPqCs85N2RvwNdlfMw4I3NL' -H 'x-auth-method: AccessToken' -u '${var.app_username}:${var.app_password}'"
}

output "post_run_curl_command" {
  value = "curl -i -X POST '${aws_api_gateway_stage.latest.invoke_url}/apexPMD?username=admin&password=n2c99skEwmWvt3Q1p7d11ne4FKwPqCs85N2RvwNdlfMw4I3NL' -H 'x-auth-method: AccessToken' -u '${var.app_username}:${var.app_password}' -H 'Content-Type: application/json' -d '{ \"backUrl\": \"fake salesforce uri\", \"sId\": \"fake salesforce token\", \"jobId\": \"fake unique job id\", \"attList\": [], \"attRuls\": [], \"branchId\": \"\" }'"
}
