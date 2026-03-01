##Repository
resource "aws_codecommit_repository" "repository" {
  repository_name = "${var.general_config["project"]}-${var.general_config["env"]}-${var.general_config["service"]}-repository"
  description     = "${var.general_config["project"]}-${var.general_config["env"]}${var.general_config["service"]}-repository"
}