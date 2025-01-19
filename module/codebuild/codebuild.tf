resource "aws_codebuild_project" "project" {
  name         = "${var.general_config["project"]}-${var.general_config["env"]}-project"
  description  = "${var.general_config["project"]}-${var.general_config["env"]}-project"
  service_role = var.iam_codebuild_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "REGION"
      value = var.region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment {
      name = "ECR_REPOSITORY_URL"
      value = var.ecr_repository_url
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "ECS_CICD"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 0
    insecure_ssl        = false
    report_build_status = false
    buildspec       = file("./buildspec.yml")
  }

  vpc_config {
    vpc_id  = var.vpc_id
    subnets = var.dmz_subnet_ids
    security_group_ids = [
      aws_security_group.common.id
    ]
  }
}