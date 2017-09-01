terraform {
  required_version = "0.10.3"
  // TODO: backend
}

provider "aws" {
  version = "0.1.4"
  region = "us-east-1"
  profile = "${var.aws_credentials_profile}"
}

