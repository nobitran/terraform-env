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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env_prefix}-vpc"
  cidr = var.vpc_cidr_block

  azs            = [var.avail_zone]
  public_subnets = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet"
  }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "web_md" {
  source                = "./modules/web"
  vpc_id                = module.vpc.vpc_id
  avail_zone            = var.avail_zone
  env_prefix            = var.env_prefix
  default_cidr_block    = var.default_cidr_block
  image_name            = var.image_name
  public_key_location   = var.public_key_location
  default_instance_type = var.default_instance_type
  subnet_id             = module.vpc.public_subnets[0]
  private_key_location  = var.private_key_location
}
