# S3 bucket ID random suffix
resource "random_id" "bucket_id" {
  byte_length = 4
}

# S3 bucket ID
resource "aws_s3_bucket" "jenkins-test1" {
  bucket        = lower("jenkins-test1-${random_id.bucket_id.hex}")
  force_destroy = true
}

# Set to allowing bucket being public
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.jenkins-test1.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket public policy
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.jenkins-test1.id

  depends_on = [aws_s3_bucket_public_access_block.allow_public

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.jenkins-test1.arn}/*"
      }
    ]
  })
}
