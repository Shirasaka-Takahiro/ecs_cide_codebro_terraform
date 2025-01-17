##Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "deafult" {
  name              = "/${var.general_config["project"]}/${var.general_config["env"]}/web01"
  retention_in_days = 30
}

##Cloudwatch Event Rule for Codecommit
resource "aws_cloudwatch_event_rule" "codepipeline_event_rule" {
  name = "${var.general_config["project"]}-${var.general_config["env"]}-codepipeline-event_rule"

  event_pattern = templatefile("${path.module}/pattern/codepipeline_event_pattern.json", {
    codecommit_repository_arn = var.codecommit_repository_arn
  })
}

##Cloudwatch Event Target for Codecommit
resource "aws_cloudwatch_event_target" "codepipeline_event_target" {
  rule     = aws_cloudwatch_event_rule.codepipeline_event_rule.name
  arn      = var.codepipeline_arn
  role_arn = var.codepipeline_event_bridge_arn
}