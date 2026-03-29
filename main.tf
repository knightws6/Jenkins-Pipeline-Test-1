# S3 bucket ID random suffix
resource "random_id" "bucket_id" {
  byte_length = 4
}

# S3 bucket ID
resource "aws_s3_bucket" "jenkins_test1" {
  bucket        = lower("jenkins-test1-${random_id.bucket_id.hex}")
  force_destroy = true
}

# Bucket public policy
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.jenkins_test1.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.jenkins_test1.arn}/*"
      }
    ]
  })
}
