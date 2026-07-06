locals {
  bucket_name = "${var.channel_name}-bucket-${lower(var.environment)}-${var.region}"
  vpc_name    = "${var.environment}-VPC"
}
