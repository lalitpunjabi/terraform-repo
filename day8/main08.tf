resource "aws_s3_bucket" "bucket1" {
  count  = 2
  bucket = var.bucket_names[count.index]

  tags = var.tags
}

resource "aws_s3_bucket" "bucket2" {
  for_each = var.bucket_name_set
  bucket   = each.key

  tags = var.tags

  depends_on = [aws_s3_bucket.bucket1]
}
