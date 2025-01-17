variable "general_config" {
  type = map(any)
}
variable "codedeploy_app_name" {}
variable "deployment_group_name" {}
variable "iam_codedeploy_arn" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "tg_blue_name" {}
variable "tg_green_name" {}
variable "alb_https_listener" {}