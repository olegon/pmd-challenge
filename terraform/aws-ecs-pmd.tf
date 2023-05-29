locals {
  apex_pmd_nginx_container_name = "nginx-pmd-proxy"
  apex_pmd_app_container_name   = "flosumhub-apex-pmd"
}

resource "aws_ecs_task_definition" "pmd" {
  family                   = "apex-pmd"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.pmd_execution_role.arn
  container_definitions = jsonencode([
    {
      name              = local.apex_pmd_nginx_container_name
      image             = var.nginx_proxy_container_image
      cpu               = 128
      memoryReservation = 128
      memory            = 256
      essential         = true
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.pmd_log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "logs"
        }
      }
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name              = local.apex_pmd_app_container_name
      image             = "${aws_ecr_repository.pmd.repository_url}:${var.apex_pmd_container_image_version}" # var.apex_pmd_container_image
      cpu               = 128
      memoryReservation = 128
      memory            = 256
      essential         = true
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          # Im creating the log group because I want to control retention period
          # awslogs-create-group  = "true"
          awslogs-group         = var.pmd_log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "logs"
        }
      }
      environment = [
        # following security best practices! :p
        { "name" : "username", "value" : var.app_username },
        { "name" : "password", "value" : var.app_password },
        # debugging container
        { "name" : "NODE_ENV", "value" : "dev" },
        { "name" : "DEBUG", "value" : "*" }
      ]
    }
  ])

}

resource "aws_ecs_service" "pmd" {
  name            = "apex-pmd"
  cluster         = module.ecs.cluster_arn
  task_definition = aws_ecs_task_definition.pmd.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = module.elb.target_group_arns[0]
    container_name   = local.apex_pmd_nginx_container_name
    container_port   = 80
  }

  network_configuration {
    subnets = module.vpc.private_subnets
    # assign_public_ip = true is required to pull images from docker hub when it on a public subnet
    # docs: https://docs.aws.amazon.com/AmazonECS/latest/userguide/fargate-task-networking.html
    assign_public_ip = false
    security_groups  = [aws_security_group.pmd_service.id]
  }
}

resource "aws_iam_role" "pmd_execution_role" {
  name               = "apex-pmd-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "pmd_execution_role_ecs_policy_attachment" {
  role       = aws_iam_role.pmd_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
