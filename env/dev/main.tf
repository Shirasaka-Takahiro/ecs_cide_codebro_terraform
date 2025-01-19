##Provider for ap-northeast-1
provider "aws" {
  profile    = "terraform-user"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-northeast-1"
}

##Network
module "network" {
  source = "../../module/network"

  general_config      = var.general_config
  availability_zones  = var.availability_zones
  vpc_id              = module.network.vpc_id
  vpc_cidr            = var.vpc_cidr
  internet_gateway_id = module.network.internet_gateway_id
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
}

##Security Group Internal
module "internal_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_blocks    = ["10.0.0.0/16"]
  sg_role        = "internal"
}

##Secutiry Group Operation
module "operation_sg_1" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_1_cidr
  sg_role        = "operation_1"
}

module "operation_sg_2" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_2_cidr
  sg_role        = "operation_2"
}

module "alb_http_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 80
  to_port        = 80
  protocol       = "tcp"
  cidr_blocks    = ["0.0.0.0/0"]
  sg_role        = "alb_http"
}

module "alb_https_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  cidr_blocks    = ["0.0.0.0/0"]
  sg_role        = "alb_https"
}

##ALB
module "alb" {
  source = "../../module/alb"

  vpc_id                   = module.network.vpc_id
  general_config           = var.general_config
  public_subnet_ids        = module.network.public_subnet_ids
  alb_http_sg_id           = module.alb_http_sg.security_group_id
  alb_https_sg_id          = module.alb_https_sg.security_group_id
  cert_alb_arn             = module.acm_alb.cert_alb_arn
  instance_ids             = module.ec2.instance_ids
}

##3
module "s3_pipeline_bucket" {
  source = "../../module/s3"

  general_config = var.general_config
  bucket_role    = "pipeline"
}

##DNS
module "domain" {
  source = "../../module/route53"

  zone_id                     = var.zone_id
  zone_name                   = var.zone_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

##ACM
module "acm_alb" {
  source = "../../module/acm"

  zone_id     = var.zone_id
  domain_name = var.domain_name
  sans        = var.sans
}

##ECS
module "ecs" {
  source = "../../module/ecs"

  general_config = var.general_config
  task_role = var.task_role
  blue_tg_arn         = module.alb.blue_tg_arn
  ecr_repository = module.ecr.ecr_repository
  fargate_cpu    = var.fargate_cpu
  fargate_memory = var.fargate_memory
  dmz_subnet_ids = module.network.dmz_subnet_ids
  internal_sg_id = module.internal_sg.security_group_id
  iam_ecs_arn    = module.iam_ecs.iam_role_arn
}

##ECR
module "ecr" {
  source = "../../module/ecr"

  regions         = var.regions
  repository_name = var.repository_name
  image_name      = var.image_name
}

##CloudWatch
module "cloudwatch" {
  source = "../../module/cloudwatch"

  general_config = var.general_config
  codecommit_repository_arn = module.codecommit.codecommit_repository_arn
  codepipeline_arn = module.codepipeline.codepipeline_arn
  codepipeline_event_bridge_arn = module.iam_codepipeline.iam_role_arn
}

##CodeCommit
module "codecommit" {
  source = "../../module/codecommit"

  general_config    = var.general_config
  repository_role = var.repository_role
}

##Codebuild
module "codebuild" {
  source = "../../module/codebuild"

  general_config    = var.general_config
  region           = var.region
  ecr_repository_url = module.ecr.ecr_repository_url
  iam_codebuild_arn = module.iam_codebuild.iam_role_arn
  vpc_id            = module.network.vpc_id
  dmz_subnet_ids    = module.network.dmz_subnet_ids
  internal_sg_id    = module.internal_sg.security_group_id
}

##CodeDeploy
module "codedeploy" {
  source = "../../module/codedeploy"

  general_config = var.general_config
  codedeploy_app_name   = var.codedeploy_app_name
  deployment_group_name = var.deployment_group_name
  iam_codedeploy_arn    = module.iam_codedeploy.iam_role_arn
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
  blue_tg_name         = module.alb.blue_tg_name
  green_tg_name         = module.alb.green_tg_name
  alb_https_listener = module.alb.alb_https_listener_arn
}

##Codepipeline
module "codepipeline" {
  source = "../../module/codepipeline"

  general_config                     = var.general_config
  iam_codepipeline_arn               = module.iam_codepipeline.iam_role_arn
  bucket_name                        = module.s3_pipeline_bucket.bucket_name
  branch_name                        = var.branch_name
  codebuild_project_name             = module.codebuild.codebuild_project_name
  codedeploy_app_name                = module.codedeploy.codedeploy_app_name
  codedeploy_deployment_group_name   = module.codedeploy.codedeploy_deployment_group_name
  task_definition_template_path      = file("../../module/ecs/json/task_definition.json")
  app_spec_template_path             = file("../../module/codedeploy/appspec.yml")
}

##IAM
module "iam_ecs" {
  source = "../../module/iam"

  role_name   = var.role_name_1
  policy_name = var.policy_name_1
  role_json   = file("../../module/ecs/iam_json/fargate_task_assume_role.json")
  policy_json = file("../../module/ecs/iam_json/task_execution_policy.json")
}

module "iam_codebuild" {
  source = "../../module/iam"

  role_name   = var.role_name_2
  policy_name = var.policy_name_2
  role_json   = file("../../module/codebuild/iam_json/codebuild_assume_role.json")
  policy_json = file("../../module/codebuild/iam_json/codebuild_build_policy.json")
}

module "iam_codedeploy" {
  source = "../../module/iam"

  role_name   = var.role_name_3
  policy_name = var.policy_name_3
  role_json   = file("../../module/codedeploy/iam_json/codedeploy_assume_role.json")
  policy_json = file("../../module/codedeploy/iam_json/codedeploy_deploy_policy.json")
}

module "iam_codepipeline" {
  source = "../../module/iam"

  role_name   = var.role_name_4
  policy_name = var.policy_name_4
  role_json   = file("../../module/codepipeline/iam_json/codepipeline_assume_role.json")
  policy_json = file("../../module/codepipeline/iam_json/codepipeline_pipeline_policy.json")
}