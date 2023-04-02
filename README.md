# Terraform, ECS + Fargate, API Gateway + NLB and PMD challenge

How can I create a ~~basic~~ not so basic workload that supports [flosumhub/apex-pmd:2.6.0 docker image](https://hub.docker.com/r/flosumhub/apex-pmd)? This repository tries to answer that.

## How do I create resources?

Inside './terraform' directory,

```bash
# install terraform and...
terraform init && terraform apply -auto-approve
```

## How do I destroy resources?

Inside './terraform' directory,

```bash
# install terraform and...
terraform destroy -auto-approve
```

## How do I test the workload?

If you trust me, inside './terraform' directory, just execute the following commands.

```bash
# GET /
eval $(terraform output --raw get_root_curl_command)

# GET /server/log
eval $(terraform output --raw get_server_log_curl_command)

# POST /apexPMD  (this one is a bit broken... try to figure it out!)
eval $(terraform output --raw post_run_curl_command)

# POST /oauth/token
eval $(terraform output --raw post_token_curl_command)
```

## How does this image works?

Try to read the source code.

```bash
# index.js (main file)
docker run -ti --rm flosumhub/apex-pmd:2.6.0 cat index.js

# ApexMD.js
docker run -ti --rm flosumhub/apex-pmd:2.6.0 cat ApexPMD.js
```

## Why is there this nginx container?

I need to log every request, including the entire body. Inside `./nginx-pmd-proxy-container`, there is the *Dockerfile* with a custom configuration.

## Is this workload expensive?

Yes, a bit... so please: **DON'T FORGET TO DESTROY EVERYTHING!**

![everyone meme](https://i.kym-cdn.com/entries/icons/original/000/008/509/everyone2.jpg)