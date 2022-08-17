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

module "subnet_md" {
  source                 = "./modules/subnet"
  vpc_id                 = aws_vpc.main.id
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
  default_route_table_id = aws_vpc.main.default_route_table_id
  default_cidr_block     = var.default_cidr_block
}

module "web_md" {
  source                = "./modules/web"
  vpc_id                = aws_vpc.main.id
  avail_zone            = var.avail_zone
  env_prefix            = var.env_prefix
  default_cidr_block    = var.default_cidr_block
  image_name            = var.image_name
  public_key_location   = var.public_key_location
  default_instance_type = var.default_instance_type
  subnet_id             = module.subnet_md.subnet.id
  private_key_location  = var.private_key_location
}
