# Terraform, ECS + Fargate, ELB and PMD challenge

How can I create a basic workload that supports [flosumhub/apex-pmd:2.5.0 docker image](https://hub.docker.com/r/flosumhub/apex-pmd)? This repository tries to answer that.

Why I did it? No one can.

## How to create resources?

```bash
# install terraform and...
terraform init && terraform apply -auto-approve
```

## How to destroy resources?

```bash
# install terraform and...
terraform destroy -auto-approve
```

## How to test the workload?

If you trust me, just execute the following commands.

```bash
# GET /
eval $(terraform output --raw get_root_curl_command)

# GET //server/log
eval $(terraform output --raw get_server_log_curl_command)

# POST //apexPMD  (this one is a bit broken... try to figure it out!)
eval $(terraform output --raw post_run_curl_command)

# POST //oauth/token
eval $(terraform output --raw post_token_curl_command)
```

## How this image works?

If you trust me, try to read the source code.

```bash
# index.js
eval $(terraform output --raw docker_cat_index_js_file)

# ApexMD.js
eval $(terraform output --raw docker_cat_apex_js_file)
```

## Is this workload expensive?

Yes, a bit... so please: **DON'T FORGET TO DESTROY EVERYTHING!**

![everyone meme](https://i.kym-cdn.com/entries/icons/original/000/008/509/everyone2.jpg)