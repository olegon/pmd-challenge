output "lb_dns_name" {
  value = module.alb.lb_dns_name
}




# there outputs are just to help! :)

output "get_root_curl_command" {
  value = "curl -i 'http://${module.alb.lb_dns_name}'"
}

output "get_server_log_curl_command" {
  value = "curl -i 'http://${module.alb.lb_dns_name}//server/log'"
}

output "post_token_curl_command" {
  value = "curl -i -X POST 'http://${module.alb.lb_dns_name}//oauth/token?username=admin&password=n2c99skEwmWvt3Q1p7d11ne4FKwPqCs85N2RvwNdlfMw4I3NL' -H 'Authorization: Basic ${base64encode("${var.app_username}:${var.app_password}")}'"
}

output "post_run_curl_command" {
  value = "curl -X POST 'http://${module.alb.lb_dns_name}//apexPMD' -d '{ \"backUrl\": \"...salesforce uri...\", \"sId\": \"...salesforce token...\", \"jobId\": \"...unique job id...\", \"attList\": [], \"attRuls\": [], \"branchId\": \"\" }'"
}


output "docker_cat_index_js_file" {
  value = "docker run -ti --rm flosumhub/apex-pmd:2.5.0 cat index.js"
}

output "docker_cat_apex_js_file" {
  value = "docker run -ti --rm flosumhub/apex-pmd:2.5.0 cat ApexPMD.js"
}




