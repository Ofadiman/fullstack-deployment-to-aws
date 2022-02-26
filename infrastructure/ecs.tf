resource "aws_ecs_cluster" "main_ecs_cluster" {
  name = "MainEcsCluster"
}

resource "aws_ecs_cluster_capacity_providers" "main_ecs_cluster_capacity_provider" {
  cluster_name = aws_ecs_cluster.main_ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

data "aws_iam_policy_document" "ecs_task_execution_role_policy" {
  statement {
    actions   = ["*"]
    resources = [aws_ecr_repository.ecr_repository.arn]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "EcsTaskExecutionRole"
  # This defines who can assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AllowECSAssumeThisRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "EcsTaskExecutionPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid      = "AllowAllActionsOnECR",
          Action   = "*",
          Effect   = "Allow",
          Resource = aws_ecr_repository.ecr_repository.arn
        },
        # Action ecr:GetAuthorizationToken must be allowed on "*" resource because AWS throws an error.
        {
          Sid : "AllowGetAuthorizationToken",
          Action = [
            "ecr:GetAuthorizationToken",
          ],
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_ecs_task_definition" "main_ecs_cluster_task_definition" {
  family                   = "MainEcsClusterTaskDefinition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      essential   = true
      image       = "715820034474.dkr.ecr.eu-west-1.amazonaws.com/fullstack_deployment_to_aws:fedd67d8275673cf5c4a6c6972f333438b245bdd"
      name        = "fullstack"
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ],
      environment : [
        # POSTGRES_DATABASE=postgres
        # POSTGRES_HOST=localhost
        # POSTGRES_PASSWORD=postgres
        # POSTGRES_PORT=5432
        # POSTGRES_USER=postgres
        # SERVER_PORT=3001
        {
          name : "POSTGRES_DATABASE",
          value : "postgres"
        },
        {
          name : "POSTGRES_HOST",
          value : aws_db_instance.database.address
        },
        {
          name : "POSTGRES_PASSWORD",
          value : random_password.database_password.result
        },
        {
          name : "POSTGRES_PORT",
          value : "5432"
        },
        {
          name : "POSTGRES_USER",
          value : "ofadiman"
        },
        {
          name : "SERVER_PORT",
          value : "80"
        },
        {
          name : "NODE_ENV",
          value : "staging"
        }
      ]
    },
  ])
}

resource "aws_security_group" "main_ecs_service_security_group" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.security_group_main_load_balancer.id]
  }

  # Terraform requires to explicitly specify egress rule that allows outbound traffic to the internet.
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "main_ecs_service" {
  name            = "MainEcsService"
  cluster         = aws_ecs_cluster.main_ecs_cluster.id
  task_definition = aws_ecs_task_definition.main_ecs_cluster_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "1.3.0"

  network_configuration {
    security_groups  = [aws_security_group.main_ecs_service_security_group.id]
    subnets          = [aws_subnet.private_subnet_eu_west_1a.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_fargate_target_group.arn
    container_name   = "fullstack"
    container_port   = 80
  }
}
