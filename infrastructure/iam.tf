resource "aws_iam_user" "sms_notf_iam_user" {
  name = "${var.aws_resource_name}"
  path = "/"
}

resource "aws_iam_group" "sms_notf_iam_group" {
  name = "${var.aws_resource_name}"
  path = "/"
}

resource "aws_iam_group_membership" "sms_notf_iam_group_membership" {
  name = "${var.aws_resource_name}"
  users = [ "${aws_iam_user.sms_notf_iam_user.name}" ]
  group = "${aws_iam_group.sms_notf_iam_group.name}"
}

resource "aws_iam_policy" "sms_notf_iam_policy" {
  name = "${var.aws_resource_name}"
  description = "Access for SMS Notifier"
  path = "/"

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

resource "aws_iam_group_policy_attachment" "sms_notf_iam_group_policy_attachment" {
  group = "${aws_iam_group.sms_notf_iam_group.name}"
  policy_arn = "${aws_iam_policy.sms_notf_iam_policy.arn}"
}

