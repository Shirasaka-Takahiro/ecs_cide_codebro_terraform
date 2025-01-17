##Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "web01" {
  name              = "/${var.general_config["project"]}/${var.general_config["env"]}/web01"
  retention_in_days = 30
}

##Cloudwatch Event Rule for Codecommit
resource "aws_cloudwatch_event_rule" "codepipeline_event_rule" {
  name = "${var.general_config["project"]}-${var.general_config["env"]}-codepipeline-event_rule"

  event_pattern = templatefile("${path.module}/ecs_json/codepipeline_event_pattern.json", {
    codecommit_arn : aws_codecommit_repository.repository.arn
  })
}

##Cloudwatch Event Target for Codecommit
resource "aws_cloudwatch_event_target" "codepipeline_event_target" {
  rule     = aws_cloudwatch_event_rule.codepipeline_event_rule.name
  arn      = aws_codepipeline.pipeline.arn
  role_arn = aws_iam_role.event_bridge_codepipeline.arn
}