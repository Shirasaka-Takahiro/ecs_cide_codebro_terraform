resource "aws_codebuild_project" "project" {
  name         = "${var.general_config["project"]}-${var.general_config["env"]}-project"
  description  = "cicd-project"
  service_role = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.regions["tokyo"]
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
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
    location        = aws_codecommit_repository.repository.clone_url_http
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  vpc_config {
    vpc_id  = aws_vpc.vpc.id
    subnets = var.dmz_subnet_ids
    security_group_ids = [
      aws_security_group.common.id
    ]
  }
}