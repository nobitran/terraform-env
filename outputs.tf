output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_name" {
  value = aws_vpc.main.tags.Name
}

output "subnet_id" {
  value = aws_subnet.main.id
}
output "subnet_name" {
  value = aws_subnet.main.tags.Name
}
output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}
output "security_group_name" {
  value = aws_security_group.ec2_sg.tags.Name
}

output "ami_latest_id" {
  value = data.aws_ami.ami_latest.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}
