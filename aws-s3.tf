module "s3_bucket_elb_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${data.aws_caller_identity.current.account_id}-pmd-elb-bucket"

  # elb logging
  acl                            = "log-delivery-write"
  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true

  # Allow deletion of non-empty bucket
  force_destroy = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
