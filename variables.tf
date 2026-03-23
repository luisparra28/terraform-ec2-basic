variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-1234567890abcdef0"
}

variable "instance_type" {
  default = "t3.medium" # 👈 esto lo vamos a romper a propósito
}

variable "public_ip" {
  default = true
}

variable "environment" {
  default = "dev"
}

variable "name" {
  default = "ec2-dev-demo"
}