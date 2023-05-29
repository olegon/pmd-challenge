resource "aws_ecr_repository" "pmd" {
  name                 = "pmd"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "push" {
  triggers = {
    apex_pmd_container_image         = var.apex_pmd_container_image
    apex_pmd_container_image_version = var.apex_pmd_container_image_version
    repository_url                   = aws_ecr_repository.pmd.repository_url
    region                           = data.aws_region.current.name
  }

  provisioner "local-exec" {
    command = "./aws-ecr.sh '${var.apex_pmd_container_image}' '${var.apex_pmd_container_image_version}' '${aws_ecr_repository.pmd.repository_url}' '${data.aws_region.current.name}'"
  }
}
