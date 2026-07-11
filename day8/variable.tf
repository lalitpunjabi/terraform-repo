variable "environment" {
  type    = string
  default = "Dev"
}

# set
variable "allowed_region" {
  description = "List of allowed AWS regions"
  type        = set(string)
  default     = ["ap-south-1", "us-east-1", "us-east-2", "us-west-1", "us-west-2"]
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "monitoring_enabled" {
  description = "Enable detailed monitoring for EC2 instances"
  type        = bool
  default     = true
}

variable "associate_public_ip_address" {
  description = "Associate public IP address with EC2 instances"
  type        = bool
  default     = true
}

# list
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}

# list
variable "allowed_vm_types" {
  description = "List of allowed VM types"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

# map
variable "tags" {
  type = map(string)
  default = {
    Name        = "Dev-EC2"
    Environment = "Dev"
    created_by  = "terraform"
  }
}

# tuple
variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [443, "tcp", 443]
}

# object
variable "config" {
  type = object({
    region         = string
    monitoring     = bool
    instance_count = number
  })
  default = {
    region         = "ap-south-1"
    monitoring     = true
    instance_count = 1
  }
}

variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = ["my_unique_bucket_081", "my_unique_bucket_082"]
}

variable "bucket_name_set" {
  description = "List of S3 bucket names to create"
  type        = set(string)
  default     = ["my_unique_bucket_083", "my_unique_bucket_084"]
}
