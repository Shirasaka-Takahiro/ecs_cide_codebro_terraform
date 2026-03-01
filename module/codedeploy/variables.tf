variable "general_config" {
  type = map(any)
}
variable "iam_codedeploy_arn" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "blue_tg_name" {}
variable "green_tg_name" {}
variable "alb_https_listener" {}