// General

variable "aws_credentials_profile" {
  type = string
}

// Deploy time

variable "aws_resource_name_deploy" {
  type    = string
  default = "sms-notf-deploy"
}

variable "deploy_bucket_name" {
  type = string
}

// Run time

variable "aws_resource_name_run" {
  type    = string
  default = "sms-notf-run"
}

variable "env_SMTP_HOST" {
  type = string
}

variable "env_SMTP_USERNAME" {
  type = string
}

variable "env_SMTP_PASSWORD" {
  type = string
}

variable "env_EMAIL_FROM" {
  type = string
}

variable "env_EMAIL_SUBJECT" {
  type = string
}

variable "env_EMAIL_MSG_FORMAT_012" {
  type = string
}

variable "env_EMAIL_MSG_FORMAT_3" {
  type = string
}

variable "env_EMAIL_MSG_FORMAT_4" {
  type = string
}

variable "env_EMAIL_TO" {
  type = string
}

variable "triggers" {
  type = map
}
