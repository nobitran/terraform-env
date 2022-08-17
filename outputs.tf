output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_name" {
  value = aws_vpc.main.tags.Name
}
output "subnet_id" {
  value = module.subnet_md.subnet.id
}
output "subnet_name" {
  value = module.subnet_md.subnet.tags.Name
}
output "security_group_id" {
  value = module.web_md.ec2_sg.id
}
output "security_group_name" {
  value = module.web_md.ec2_sg.tags.Name
}

output "ami_latest_id" {
  value = module.web_md.ami_latest_id
}

output "ec2_public_ip" {
  value = module.web_md.ec2.public_ip
}
