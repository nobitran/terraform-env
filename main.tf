terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


variable "main_vpc_cidr_block" {
  type = string
}

variable "main_subnet_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}



provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "main-vpc" {
  cidr_block = var.main_vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "main-subnet" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.main_subnet_cidr_block
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = var.subnet_name
  }
}

data "aws_vpc" "default-vpc" {
  default = true
}

resource "aws_subnet" "sub-subnet" {
  vpc_id            = data.aws_vpc.default-vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "Sub-Subnet"
  }
}
