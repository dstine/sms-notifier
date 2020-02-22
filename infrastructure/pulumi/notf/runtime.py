# Manages infrastructure for running application code
# A lambda function and associated resources

import json

import pulumi
import pulumi_aws as aws

from pulumi_aws import iam

REGION='us-east-1'
ACCOUNT_ID=aws.get_caller_identity().account_id
RESOURCE_NAME='sms-notf-run-pulumi'

def create_iam(tags):

    policy = json.dumps({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": [
                    f"arn:aws:logs:{REGION}:{ACCOUNT_ID}:log-group:${RESOURCE_NAME}:*"
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
    })

    iam_policy = iam.Policy(RESOURCE_NAME, path='/', policy=policy)

    assume_role_policy = json.dumps({
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
    })

    role = iam.Role(RESOURCE_NAME, assume_role_policy=assume_role_policy, tags=tags)

    role_policy_attachment = iam.RolePolicyAttachment(RESOURCE_NAME, policy_arn=iam_policy.arn, role=role)

