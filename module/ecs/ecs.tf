##Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.general_config["project"]}-${var.general_config["env"]}-${var.cluster_role}-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

##Task Definition
resource "aws_ecs_task_definition" "task" {
  family = "${var.general_config["project"]}-${var.general_config["env"]}-${var.cluster_role}-task"
  container_definitions = templatefile("${path.module}/json/container_definitions.json",
    {
      ecr_repository_url = var.ecr_repository,
      project            = var.general_config["project"],
      env                = var.general_config["env"]
      execution_role_arn = var.iam_ecs_arn
    }
  )
  cpu                = var.fargate_cpu
  memory             = var.fargate_memory
  network_mode       = "awsvpc"
  execution_role_arn = var.iam_ecs_arn

  requires_compatibilities = [
    "FARGATE"
  ]
}

##Service
resource "aws_ecs_service" "service" {
  name             = "${var.general_config["project"]}-${var.general_config["env"]}-${var.cluster_role}-service"
  cluster          = aws_ecs_cluster.cluster.arn
  task_definition  = templatefile("${path.module}/json/task_definition.json",
    {
      ecr_repository_url = var.ecr_repository,
      cw_log_group       = var.cloudwatch_log_group_name,
      project            = var.general_config["project"],
      env                = var.general_config["env"]
    }
  )
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    target_group_arn = var.tg_blue_arn
    container_name   = "${var.general_config["project"]}-${var.general_config["env"]}-web01"
    container_port   = "80"
  }

  network_configuration {
    subnets = var.dmz_subnet_ids
    security_groups = [
      var.internal_sg_id
    ]
    assign_public_ip = false
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}