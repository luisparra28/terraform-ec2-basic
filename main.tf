provider "aws" {
  region = var.region
  access_key = "***"
  secret_key = "***"
}

resource "aws_instance" "demo" {
  ami           = var.ami
  instance_type = var.instance_type

  associate_public_ip_address = var.public_ip

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