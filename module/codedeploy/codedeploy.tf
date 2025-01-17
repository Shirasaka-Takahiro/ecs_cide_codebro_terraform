##CodeDeploy
resource "aws_codedeploy_app" "default" {
  compute_platform = "ECS"
  name             = "${var.general_config["project"]}-${var.general_config["env"]}-${var.codedeploy_app_name}"
}

resource "aws_codedeploy_deployment_group" "default" {
  app_name              = aws_codedeploy_app.default.name
  deployment_group_name = "${var.general_config["project"]}-${var.general_config["env"]}-${var.deployment_group_name}"

  service_role_arn       = var.iam_codedeploy_arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_https_listener]
      }

      target_group {
        name = var.tg_blue_name
      }

      target_group {
        name = var.tg_green_name
      }
    }
  }
  
}