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
  timeout       = "30"
  s3_bucket     = "${var.s3_bucket_name}"
  s3_key        = "sms-notifier.zip"

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

  tags {
    terraform = "true"
  }
}

resource "aws_lambda_permission" "sms_notf_run_on_hour" {
  statement_id  = "${var.aws_resource_name_run}-on-hour"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sms_notf_run.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.sms_notf_run_on_hour.arn}"
}

resource "aws_lambda_permission" "sms_notf_run_on_half_hour" {
  statement_id  = "${var.aws_resource_name_run}-on-half-hour"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sms_notf_run.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.sms_notf_run_on_half_hour.arn}"
}

resource "aws_cloudwatch_log_group" "sms_notf_run" {
  name = "/aws/lambda/${var.aws_resource_name_run}"

  tags {
    terraform = "true"
  }
}

resource "aws_cloudwatch_event_rule" "sms_notf_run_on_hour" {
  name                = "${var.aws_resource_name_run}-on-hour"
  description         = "Triggers on the hour (:00)"
  schedule_expression = "${var.trigger_cron_on_hour}"
}

resource "aws_cloudwatch_event_rule" "sms_notf_run_on_half_hour" {
  name                = "${var.aws_resource_name_run}-on-half-hour"
  description         = "Triggers on the half hour (:30)"
  schedule_expression = "${var.trigger_cron_on_half_hour}"
}

resource "aws_cloudwatch_event_target" "sms_notf_run_on_hour" {
  rule      = "${aws_cloudwatch_event_rule.sms_notf_run_on_hour.name}"
  target_id = "${aws_lambda_function.sms_notf_run.function_name}"
  arn       = "${aws_lambda_function.sms_notf_run.arn}"
}

resource "aws_cloudwatch_event_target" "sms_notf_run_on_half_hour" {
  rule      = "${aws_cloudwatch_event_rule.sms_notf_run_on_half_hour.name}"
  target_id = "${aws_lambda_function.sms_notf_run.function_name}"
  arn       = "${aws_lambda_function.sms_notf_run.arn}"
}
