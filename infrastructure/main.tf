terraform {
  required_version = "0.11.2"

  backend "s3" {
    bucket  = "com.github.dstine.terraform"
    key     = "sms-notf.tfstate"
    region  = "us-east-1"
    profile = "terraform-backend"
  }
}

provider "aws" {
  version = "1.7.0"
  region  = "us-east-1"
  profile = "${var.aws_credentials_profile}"
}

data "aws_caller_identity" "current" {}
