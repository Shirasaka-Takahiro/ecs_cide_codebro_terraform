##IAM Role
resource "aws_iam_role" "default" {
  name               = var.role_name
  assume_role_policy = var.role_json
}

##IAM Role Policy
resource "aws_iam_role_policy" "default" {
  name   = var.policy_name
  role   = aws_iam_role.default.name
  policy = var.policy_json
}