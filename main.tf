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
  source = "build/libs/${var.BUILD_FILENAME}"

  etag = filemd5("build/libs/${var.BUILD_FILENAME}")
}

variable "BUILD_FILENAME" {
  type = string
}

output "BUILD_FILENAME_OUTPUT" {
  value = var.BUILD_FILENAME
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_tomcat" {
  name        = "allow_tomcat"
  description = "Allow tomcat default inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tomcat"
  }
}

resource "aws_instance" "zoo-spring-server" {
  ami           = "ami-08e4e35cccc6189f4"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2-zoo-profile.name
  key_name = "t4-cicd"
  security_groups = ["allow_tomcat"]


  user_data = <<EOF
#!/bin/bash
sudo yum -y update && sudo yum -y upgrade
sudo yum install -y java-11-amazon-corretto-headless
aws s3api get-object --bucket "${random_pet.jar_bucket_name.id}" --key "${var.BUILD_FILENAME}" "${var.BUILD_FILENAME}"
java -jar ${var.BUILD_FILENAME}
EOF
  tags = {
    Name = "Zoo Spring Server"
  }

  depends_on = [
    aws_security_group.allow_tomcat
  ]

}

resource "aws_iam_role" "ec2_assume" {
  name = "ec2_assume"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      Name = "ec2_assume"
  }
}

resource "aws_iam_instance_profile" "ec2-zoo-profile" {
  name = "ec2-zoo-profile"
  role = "${aws_iam_role.ec2_assume.name}"
}

resource "aws_iam_role_policy" "s3_access" {
  name = "s3_access"
  role = "${aws_iam_role.ec2_assume.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${random_pet.jar_bucket_name.id}/*",
                "arn:aws:s3:::${random_pet.jar_bucket_name.id}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        }
    ]
}
EOF
}