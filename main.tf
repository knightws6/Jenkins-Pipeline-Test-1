terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-west-2"
}

#random suffix, s3 bucket names must be globally unique
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "test" {
  bucket = lower("Jenkins-test-bucket-bucket-${random_id.bucket_id.hex}")   # must be globally unique, hence random_id
  force_destroy = true
}
