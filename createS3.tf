# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create an S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-s3-bucket"

  # Enable versioning
  versioning {
    enabled = true
  }

  # Configure server-side encryption with AWS KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcdef0123456789abcdef0123456789abcdef0123456789" 
      }
    }
  }

  # Configure logging
  logging {
    target_bucket = "my-s3-bucket-logs"
    target_prefix = "logs/"
  }

  # Configure lifecycle rules
  lifecycle_rule {
    id     = "archive-old-objects"
    prefix = "archive/"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }
  }
}