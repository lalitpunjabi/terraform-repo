output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}
