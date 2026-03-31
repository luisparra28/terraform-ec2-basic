provider "aws" {
  region = var.region
  access_key = "***"
  secret_key = "***"
}

resource "aws_instance" "demo" {
  ami           = var.ami
  instance_type = var.instance_type

  associate_public_ip_address = var.public_ip

  root_block_device {
    encrypted = false
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }
  

  #ebs_block_device {
  #  device_name = "test_volume"
  #  encrypted = false
  #}

  tags = {
    Name        = var.name
    Environment = var.environment
    Owner       = "Luis"
  }
}

resource "aws_s3_bucket" "demo" {
  bucket = "mi-bucket-test"
}

#resource "aws_s3_bucket_public_access_block" "demo" {
#  bucket = aws_s3_bucket.demo.id
#
#  block_public_acls       = true
#  block_public_policy     = true
#  ignore_public_acls      = true
#  restrict_public_buckets = true
#}

#resource "aws_db_instance" "demo" {
#  instance_class     = "db.t3.small"
#  storage_encrypted  = false
#  allocated_storage  = 50
#  multi_az           = false
#}

# IAM role for Lambda execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "demo" {
  function_name = "demo_function"
  role = aws_iam_role.example.arn
  handler                = "index.lambda_handler"
  runtime                = "python3.12"

  s3_bucket = aws_s3_bucket.demo.id
  s3_key = "/"

  memory_size = 2048
  timeout     = 120

  architectures = ["x86_64"] #arm64

  ephemeral_storage {
    size = 1024
  }
}