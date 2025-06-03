resource "aws_s3_bucket" "buckets" {
  bucket = var.s3_bucket_landing

  force_destroy = true

}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse" {
  bucket = var.s3_bucket_landing

  depends_on = [ aws_s3_bucket.buckets ]

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = var.s3_bucket_landing

  depends_on = [ aws_s3_bucket.buckets ]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}