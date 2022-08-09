# declare variable
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "key_name" {}
variable "public_key_location" {}
variable "private_key_location" {}


# define variable
variable "default_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Default CIDR block"
}

variable "default_instance_type" {
  default     = "t2.micro"
  description = "Default Instance Type"
}
