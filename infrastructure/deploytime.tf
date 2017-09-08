// Manages infrastructure for deploying application code updates
// A user with ability to push code to S3

// TODO: create S3 bucket

resource "aws_iam_user" "sms_notf_deploy_iam_user" {
  name = "${var.aws_resource_name_deploy}"
  path = "/"
}

resource "aws_iam_group" "sms_notf_deploy_iam_group" {
  name = "${var.aws_resource_name_deploy}"
  path = "/"
}

resource "aws_iam_group_membership" "sms_notf_deploy_iam_group_membership" {
  name  = "${var.aws_resource_name_deploy}"
  users = ["${aws_iam_user.sms_notf_deploy_iam_user.name}"]
  group = "${aws_iam_group.sms_notf_deploy_iam_group.name}"
}

resource "aws_iam_policy" "sms_notf_deploy_iam_policy" {
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
        "arn:aws:s3:::${var.s3_bucket_name}",
        "arn:aws:s3:::${var.s3_bucket_name}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "sms_notf_deploy_iam_group_policy_attachment" {
  group      = "${aws_iam_group.sms_notf_deploy_iam_group.name}"
  policy_arn = "${aws_iam_policy.sms_notf_deploy_iam_policy.arn}"
}
