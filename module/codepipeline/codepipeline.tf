##Codepipeline
resource "aws_codepipeline" "pipeline" {
  name     = "${var.general_config["project"]}-${var.general_config["env"]}-pipeline"
  role_arn = var.iam_codepipeline_arn

  artifact_store {
    location = var.bucket_name
    type     = "S3"
  }

  ##Source Stage
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = "${var.general_config["project"]}-${var.general_config["env"]}-repository"
        BranchName       = var.branch_name
      }
    }
  }

  ##Build Stage
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  ##Deploy Stage
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = var.codedeploy_app_name
        DeploymentGroupName = var.codedeploy_deployment_group_name
        TaskDefinitionTemplateArtifact = "build_output"
        TaskDefinitionTemplatePath     = var.task_definition_template_path
        AppSpecTemplateArtifact        = "build_output"
        AppSpecTemplatePath            = var.app_spec_template_path
        Image1ArtifactName             = "BuildArtifact"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }
}