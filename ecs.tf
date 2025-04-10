resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_role_policy" {
  name       = "ecsTaskExecutionRolePolicyAttachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "spotifind-ecs-cluster"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "spotifind-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "spotifind-container"
      image     = "${aws_ecr_repository.ecr_repo.repository_url}@${data.aws_ecr_image.latest_image.image_digest}"
      cpu       = 256
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = var.port
          hostPort      = var.port
          protocol      = "tcp"
        }
      ]

      # healthCheck = {
      #   "command"     = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
      #   "interval"    = 30
      #   "timeout"     = 5
      #   "retries"     = 3
      #   "startPeriod" = 10
      # }

      secrets = [
        for param in aws_ssm_parameter.env_vars : {
          name = split("/", param.name)[length(split("/", param.name)) - 1]
          valueFrom = param.arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region" = "ap-southeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "spotifind-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name = "spotifind-container"
    container_port = var.port
  }

  depends_on = [ aws_lb_listener.http_redirect, aws_lb_listener.https ]
}

resource "aws_security_group" "ecs_sg" {
  name        = "spotifind_ecs_sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "ecs/spotifind-logs"

  retention_in_days = 30
}
