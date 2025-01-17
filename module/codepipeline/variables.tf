variable "general_config" {
  type = map(any)
}
variable "iam_codepipeline_arn" {}
variable "bucket_name" {}
variable "full_repositroy_id" {}
variable "branch_name" {}
variable "codebuild_project_name" {}
variable "codedeploy_app_name" {}
variable "codedeploy_deployment_group_name" {}
variable "codestarconnections_connection_arn" {}
variable "task_definition_template_path" {}
variable "app_spec_template_path" {}