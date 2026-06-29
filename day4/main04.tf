terraform {
    backend "s3" {
    bucket = "lalit-tf-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

# Create s3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = "lalit-bucket-tf"

  tags = {
    Name        = "My bucket 2.0"
    Environment = "Dev"
  }
}