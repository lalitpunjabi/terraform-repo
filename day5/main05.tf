terraform {
  backend "s3" {
    bucket       = "lalit-tf-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#############################
# Variables
#############################

variable "environment" {
  default = "Dev"
}

variable "channel_name" {
  default = "lalit"
}

variable "region" {
  default = "ap-south-1"
}

#############################
# Locals
#############################

locals {
  bucket_name = "${var.channel_name}-bucket-${lower(var.environment)}-${var.region}"
  vpc_name    = "${var.environment}-VPC"
}

#############################
# Latest Amazon Linux 2023 AMI
#############################

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

#############################
# S3 Bucket
#############################

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}

#############################
# VPC
#############################

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = local.vpc_name
  }
}

#############################
# Public Subnet
#############################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

#############################
# Internet Gateway
#############################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main-IGW"
  }
}

#############################
# Route Table
#############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RouteTable"
  }
}

#############################
# Route Table Association
#############################

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#############################
# Security Group
#############################

resource "aws_security_group" "web" {
  name   = "web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

#############################
# EC2 Instance
#############################

resource "aws_instance" "example" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.environment}-EC2"
    Environment = var.environment
  }
}

#############################
# Outputs
#############################

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}
