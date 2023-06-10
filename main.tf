variable "aws_access_key" {
  description = "aws access key"
}

variable "aws_access_secret" {
  description = "aws access secret"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_access_secret
  region = "ap-southeast-2"
}

resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group for the web application"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "web-app-instance"
  }
}
