variable "general_config" {
  type = map(any)
}
variable "region" {}
variable "ecr_repository_url" {}
variable "iam_codebuild_arn" {}
variable "vpc_id" {}
variable "dmz_subnet_ids" {}
variable "internal_sg_id" {}