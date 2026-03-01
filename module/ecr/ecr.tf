##ECR Repository
resource "aws_ecr_repository" "default" {
  name                 = "${var.general_config["project"]}-${var.general_config["env"]}-${var.general_config["service"]}-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}