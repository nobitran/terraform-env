output "ec2" {
  value = aws_instance.ec2
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg
}

output "ami_latest_id" {
  value = data.aws_ami.ami_latest.id
}