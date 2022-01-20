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

  key    = "zoo-tdd-demo-0.0.1-SNAPSHOT.jar"
  source = "build/libs/zoo-tdd-demo-0.0.1-SNAPSHOT.jar"

  etag = filemd5("build/libs/zoo-tdd-demo-0.0.1-SNAPSHOT.jar")
  }