variable "id" {
  type = "string"
}

variable "aws_resource_name" {
  type = "string"
}

variable "function_name" {
  type = "string"
}

variable "function_arn" {
  type = "string"
}

variable "cron_expression" {
  type = "string"
}

resource "aws_cloudwatch_event_rule" "sms_notf_run" {
  name                = "${var.aws_resource_name}-${var.id}"
  description         = "Trigger ${var.id}"
  schedule_expression = "${var.cron_expression}"
}

resource "aws_cloudwatch_event_target" "sms_notf_run" {
  rule      = "${aws_cloudwatch_event_rule.sms_notf_run.name}"
  target_id = "${var.function_name}"
  arn       = "${var.function_arn}"
}

resource "aws_lambda_permission" "sms_notf_run" {
  statement_id  = "${var.aws_resource_name}-${var.id}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.sms_notf_run.arn}"
}
