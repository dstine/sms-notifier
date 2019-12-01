// Manages infrastructure for deploying application code updates
// A user with ability to push code to S3

resource "aws_s3_bucket" "sms_notf_deploy" {
  bucket = "${var.deploy_bucket_name}"
  acl    = "private"

  lifecycle {
    prevent_destroy = "true"
  }

  tags {
    project   = "sms-notifier"
    terraform = "true"
  }
}

resource "aws_iam_user" "sms_notf_deploy" {
  name = "${var.aws_resource_name_deploy}"
  path = "/"
}

resource "aws_iam_group" "sms_notf_deploy" {
  name = "${var.aws_resource_name_deploy}"
  path = "/"
}

resource "aws_iam_group_membership" "sms_notf_deploy" {
  name  = "${var.aws_resource_name_deploy}"
  users = ["${aws_iam_user.sms_notf_deploy.name}"]
  group = "${aws_iam_group.sms_notf_deploy.name}"
}

resource "aws_iam_policy" "sms_notf_deploy" {
  name        = "${var.aws_resource_name_deploy}"
  description = "Access for SMS Notifier Deployment"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.deploy_bucket_name}",
        "arn:aws:s3:::${var.deploy_bucket_name}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "sms_notf_deploy" {
  group      = "${aws_iam_group.sms_notf_deploy.name}"
  policy_arn = "${aws_iam_policy.sms_notf_deploy.arn}"
}
