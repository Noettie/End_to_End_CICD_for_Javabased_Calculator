provider "aws" {
  region = "us-east-2"
}

# Fetch the latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "petra_sg" {
  name        = "petra-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

resource "aws_instance" "build_server" {
  ami               = data.aws_ami.amazon_linux_2.id
  instance_type     = "t2.micro"
  key_name          = "petra-hs-project" # Make sure this key exists in your AWS account
  security_groups   = [aws_security_group.petra_sg.name]

  tags = {
    Name = "build-server"
  }
}

resource "aws_instance" "deploy_server" {
  ami               = data.aws_ami.amazon_linux_2.id
  instance_type     = "t2.micro"
  key_name          = "petra-hs-project"
  security_groups   = [aws_security_group.petra_sg.name]

  tags = {
    Name = "deploy-server"
  }
}

output "build_server_ip" {
  value = aws_instance.build_server.public_ip
}

output "deploy_server_ip" {
  value = aws_instance.deploy_server.public_ip
}

