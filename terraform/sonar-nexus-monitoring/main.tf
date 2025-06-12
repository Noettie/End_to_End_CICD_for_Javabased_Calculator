provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP/HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = element(var.subnet_ids, 0)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = { Name = "SonarQube-Server" }
}

resource "aws_instance" "nexus" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = element(var.subnet_ids, 1)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = { Name = "Nexus-Server" }
}

#resource "aws_instance" "prometheus_grafana" {
# ami                    = data.aws_ami.amazon_linux_2.id
# instance_type          = var.instance_type
# key_name               = var.key_name
# subnet_id              = element(var.subnet_ids, 2)
# vpc_security_group_ids = [aws_security_group.ec2_sg.id]
# tags = { Name = "Prometheus-Grafana-Server" }
#}

# New PostgreSQL DB Server
resource "aws_instance" "postgres_db" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.db_instance_type
  key_name               = var.key_name
  subnet_id              = element(var.subnet_ids, 3)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = { Name = "PostgreSQL-DB-Server" }
}
