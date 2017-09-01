// Manages infrastructure for running code
// A lambda function and associated resources

resource "aws_iam_policy" "sms_notf_run_iam_policy" {
  name = "${var.aws_resource_name_run}"
  description = "Access for SMS Notifier Lambda function"
  path = "/"

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
        "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.aws_resource_name_run}:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "sms_notf_run_iam_role" {
  name = "${var.aws_resource_name_run}"
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

resource "aws_iam_role_policy_attachment" "sms_notf_run_iam_role_policy_attachment" {
  role = "${aws_iam_role.sms_notf_run_iam_role.name}"
  policy_arn = "${aws_iam_policy.sms_notf_run_iam_policy.arn}"
}

resource "aws_lambda_function" "sms_notf_run_lambda_function" {
  function_name = "${var.aws_resource_name_run}"
  role = "${aws_iam_role.sms_notf_run_iam_role.arn}"
  handler = "com.github.dstine.sms.SmsHandler::handleRequest"
  runtime = "java8"
  timeout = "30"
  s3_bucket = "${var.s3_bucket_name}"
  s3_key = "sms-notifier.zip"
  environment {
    variables = {
      SMTP_HOST        = "${var.env_SMTP_HOST}"
      SMTP_USERNAME    = "${var.env_SMTP_USERNAME}"
      SMTP_PASSWORD    = "${var.env_SMTP_PASSWORD}"
      EMAIL_SUBJECT    = "${var.env_EMAIL_SUBJECT}"
      EMAIL_FROM       = "${var.env_EMAIL_FROM}"
      EMAIL_MSG_FORMAT = "${var.env_EMAIL_MSG_FORMAT}"
      EMAIL_TO         = "${var.env_EMAIL_TO}"
    }
  }
}

// TODO: CloudWatch resources

resource "aws_cloudwatch_log_group" "sms_notf_run_cloudwatch_log_group" {
  name = "/aws/lambda/${var.aws_resource_name_run}"
}
