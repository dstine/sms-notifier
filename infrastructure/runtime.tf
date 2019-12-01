// Manages infrastructure for running application code
// A lambda function and associated resources

resource "aws_iam_policy" "sms_notf_run" {
  name        = "${var.aws_resource_name_run}"
  description = "Access for SMS Notifier Lambda function"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.sms_notf_run.name}:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "sms_notf_run" {
  name        = "${var.aws_resource_name_run}"
  description = "Runtime role for SMS Notifier Lambda function"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sms_notf_run" {
  role       = "${aws_iam_role.sms_notf_run.name}"
  policy_arn = "${aws_iam_policy.sms_notf_run.arn}"
}

resource "aws_lambda_function" "sms_notf_run" {
  function_name = "${var.aws_resource_name_run}"
  role          = "${aws_iam_role.sms_notf_run.arn}"
  handler       = "com.github.dstine.sms.SmsHandler::handleRequest"
  runtime       = "java8"
  memory_size   = "256"
  timeout       = "60"
  s3_bucket     = "${var.deploy_bucket_name}"
  s3_key        = "sms-notifier.zip"

  environment {
    variables = {
      SMTP_HOST        = "${var.env_SMTP_HOST}"
      SMTP_USERNAME    = "${var.env_SMTP_USERNAME}"
      SMTP_PASSWORD    = "${var.env_SMTP_PASSWORD}"
      EMAIL_SUBJECT    = "${var.env_EMAIL_SUBJECT}"
      EMAIL_FROM       = "${var.env_EMAIL_FROM}"
      EMAIL_TO         = "${var.env_EMAIL_TO}"
    }
  }

  tags {
    project   = "sms-notifier"
    terraform = "true"
  }
}

resource "aws_cloudwatch_log_group" "sms_notf_run" {
  name = "/aws/lambda/${var.aws_resource_name_run}"

  tags {
    project   = "sms-notifier"
    terraform = "true"
  }
}

// Number of module instances should match length of triggers variable
// https://github.com/hashicorp/terraform/issues/953

module "trigger0" {
  source            = "./trigger"
  id                = "0"
  aws_resource_name = "${var.aws_resource_name_run}"
  function_name     = "${aws_lambda_function.sms_notf_run.function_name}"
  function_arn      = "${aws_lambda_function.sms_notf_run.arn}"
  function_input    = "{ \"msgFormat\": \"${var.env_EMAIL_MSG_FORMAT_012}\" }"
  cron_expressions  = "${var.triggers}"
}

module "trigger1" {
  source            = "./trigger"
  id                = "1"
  aws_resource_name = "${var.aws_resource_name_run}"
  function_name     = "${aws_lambda_function.sms_notf_run.function_name}"
  function_arn      = "${aws_lambda_function.sms_notf_run.arn}"
  function_input    = "{ \"msgFormat\": \"${var.env_EMAIL_MSG_FORMAT_012}\" }"
  cron_expressions  = "${var.triggers}"
}

module "trigger2" {
  source            = "./trigger"
  id                = "2"
  aws_resource_name = "${var.aws_resource_name_run}"
  function_name     = "${aws_lambda_function.sms_notf_run.function_name}"
  function_arn      = "${aws_lambda_function.sms_notf_run.arn}"
  function_input    = "{ \"msgFormat\": \"${var.env_EMAIL_MSG_FORMAT_012}\" }"
  cron_expressions  = "${var.triggers}"
}

module "trigger3" {
  source            = "./trigger"
  id                = 3
  aws_resource_name = "${var.aws_resource_name_run}"
  function_name     = "${aws_lambda_function.sms_notf_run.function_name}"
  function_arn      = "${aws_lambda_function.sms_notf_run.arn}"
  function_input    = "{ \"msgFormat\": \"${var.env_EMAIL_MSG_FORMAT_3}\" }"
  cron_expressions  = "${var.triggers}"
}

module "trigger4" {
  source            = "./trigger"
  id                = 4
  aws_resource_name = "${var.aws_resource_name_run}"
  function_name     = "${aws_lambda_function.sms_notf_run.function_name}"
  function_arn      = "${aws_lambda_function.sms_notf_run.arn}"
  function_input    = "{ \"msgFormat\": \"${var.env_EMAIL_MSG_FORMAT_4}\" }"
  cron_expressions  = "${var.triggers}"
}
