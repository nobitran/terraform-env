output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_name" {
  value = module.vpc.name
}
output "subnet_ids" {
  value = module.vpc.public_subnets
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
