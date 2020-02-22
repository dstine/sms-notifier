terraform {
  required_version = "0.12.15"

  backend "s3" {
    bucket  = "com.github.dstine.terraform"
    key     = "sms-notf.tfstate"
    region  = "us-east-1"
    profile = "terraform-backend"
  }
}

provider "aws" {
  version = "2.50.0"
  region  = "us-east-1"
  profile = var.aws_credentials_profile
}

data "aws_caller_identity" "current" {}
