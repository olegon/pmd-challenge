resource "aws_ecs_task_definition" "pmd" {
  family                   = "apex-pmd"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.pmd_execution_role.arn
  container_definitions = jsonencode([
    {
      name              = "apex-pmd"
      image             = "flosumhub/apex-pmd:2.5.0"
      cpu               = 256
      memoryReservation = 256
      memory            = 512
      essential         = true
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          # Im creating the log group because I want to control retention period
          # awslogs-create-group  = "true"
          awslogs-group         = "ecs-awslog-flosunhub-apex-pmd"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs-awslog-flosunhub-apex-pmd"
        }
      }
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      environment = [
        # following security best practices! :p
        { "name" : "username", "value" : var.app_username },
        { "name" : "password", "value" : var.app_password }
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
    container_name   = "apex-pmd"
    container_port   = 5000
  }

  network_configuration {
    subnets = module.vpc.private_subnets
    # assign_public_ip = true is required to pull images from docker hub when it on a public subnet
    # docs: https://docs.aws.amazon.com/AmazonECS/latest/userguide/fargate-task-networking.html
    assign_public_ip = false
    security_groups  = [aws_security_group.pmd.id]
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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.pmd_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
