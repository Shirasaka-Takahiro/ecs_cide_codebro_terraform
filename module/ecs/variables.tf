variable "general_config" {
  type = map(any)
}
variable "task_role" {}
variable "fargate_cpu" {}
variable "fargate_memory" {}
variable "iam_ecs_arn" {}
variable "blue_tg_arn" {}
variable "ecr_repository" {}
variable "dmz_subnet_ids" {}
variable "internal_sg_id" {}