# S3 bucket ID random suffix
resource "random_id" "bucket_id" {
  byte_length = 4
}

# S3 bucket name
resource "aws_s3_bucket" "jenkins_test1" {
  bucket        = lower("jenkins-test1-${random_id.bucket_id.hex}")
  force_destroy = true
}
