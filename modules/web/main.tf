
resource "aws_security_group" "ec2_sg" {
  name        = "${var.env_prefix}-ec2-sg"
  description = "Allow request for EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.default_cidr_block]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
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
    values = [var.image_name]
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
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  availability_zone           = var.avail_zone
  key_name                    = aws_key_pair.ec2_key.key_name
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    agent       = "false"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.private_key_location)
  }

  # provisioner "file" {
  #   source      = "script.sh"
  #   destination = "script.sh"
  # }

  provisioner "remote-exec" {
    script = "script.sh"
  }

  provisioner "local-exec" {
    command = "ssh -T -o StrictHostKeyChecking=no ec2-user@${self.public_ip}"
    on_failure = continue
  }

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  tags = {
    Name = "${var.env_prefix}-ec2-server"
  }
}
