terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_prefix}-rt"
  }
}

resource "aws_route_table_association" "rt_subnet" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_default_route_table.default.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.env_prefix}-ec2-sg"
  description = "Allow request for EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.default_cidr_block]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.default_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_cidr_block]
  }

  tags = {
    Name = "${var.env_prefix}-ec2-sg"
  }
}

data "aws_ami" "ami_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ami_latest.id
  instance_type               = var.default_instance_type
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  availability_zone           = var.avail_zone
  key_name                    = aws_key_pair.ec2_key.key_name
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.private_key_location)
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/home/ec2-user/script-on-ec2.sh"
  }

  provisioner "remote-exec" {
    script = "script.sh"
  }

  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no ec2-user@${self.public_ip}"
  }

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  tags = {
    Name = "${var.env_prefix}-ec2-server"
  }
}
