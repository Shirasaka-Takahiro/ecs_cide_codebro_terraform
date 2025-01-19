##Default Bucket
resource "aws_s3_bucket" "default_bucket" {
  bucket = "${var.general_config["project"]}-${var.general_config["env"]}-${var.bucket_role}-bucket"

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-${var.bucket_role}-bucket"
  }
}

##Public Access Block
resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket                  = aws_s3_bucket.default_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##Versioning
resource "aws_s3_bucket_versioning" "bucket_versiong" {
  bucket = aws_s3_bucket.default_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

##Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption" {
  bucket = aws_s3_bucket.default_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##Default Bucket Policy
data "aws_iam_policy_document" "iam_policy_default" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.default_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}