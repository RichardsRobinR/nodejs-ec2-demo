terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "terraform-bucket-002"
    key    = "terraform-bucket-002.tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

resource "random_pet" "sg" {}

resource "aws_instance" "app_server" {
  ami           = "ami-0ff72998b38e59e40"
  instance_type = "t2.micro"

  tags = {
    Name = "AppServerInstance"
  }
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}