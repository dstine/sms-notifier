variable "aws_credentials_profile" {
  type = "string"
}

variable "aws_resource_name_deploy" {
  type = "string"
  default = "sms-notf-deploy"
}

variable "aws_resource_name_run" {
  type = "string"
  default = "sms-notf-run"
}

variable "s3_bucket_name" {
  type = "string"
}

