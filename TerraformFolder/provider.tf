terraform {
  backend "s3" {
    bucket         = "terraform-statefiles-bucket-infrastructure"
    key            = "EC2-Instance-Creation/ec2creation.tfstate"
    region         = "us-east-1"
    dynamodb_table = "EC2-Creation-table"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.accountID}:role/${var.iam_role}"
  }
}

provider "random" {
  # Configuration options
}

provider "null" {
  # Configuration options
}
