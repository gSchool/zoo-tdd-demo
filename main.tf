terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
      }
    }
  }

  # Configure the AWS Provider
  provider "aws" {
    region = "us-east-1"
  }

  # Create a VPC
  resource "random_pet" "jar_bucket_name" {
    prefix = "zoo-tdd"
    length = 4
  }

  resource "aws_s3_bucket" "jar_bucket" {
    bucket = random_pet.jar_bucket_name.id

    acl           = "private"
    force_destroy = true
  }

  resource "aws_s3_bucket_object" "jar_artifact" {
  bucket = aws_s3_bucket.jar_bucket.id

  key    = var.BUILD_FILENAME
  source = var.BUILD_FILENAME

  etag = filemd5(var.BUILD_FILENAME)
  }

  variable "BUILD_FILENAME" {
    type        = string
  }

  output "BUILD_FILENAME_OUTPUT" {
    value = var.BUILD_FILENAME
  }