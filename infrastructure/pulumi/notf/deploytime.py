# Manages infrastructure for running application code
# A lambda function and associated resources

import json

from pulumi_aws import iam
from pulumi_aws import s3

import notf.config

RESOURCE_NAME = 'sms-notf-deploy-pulumi'


def create(deploy_bucket_name, tags):

    _create_s3(deploy_bucket_name, tags)
    _create_iam(deploy_bucket_name, tags)


def _create_s3(deploy_bucket_name, tags):

    bucket = s3.Bucket(
        RESOURCE_NAME,
        acl='private',
        tags=tags,
    )

    s3.BucketPublicAccessBlock(
        RESOURCE_NAME,
        bucket=bucket,
        block_public_acls=True,
        block_public_policy=True,
        ignore_public_acls=True,
        restrict_public_buckets=True,
    )

def _create_iam(deploy_bucket_name, tags):

    user = iam.User(
        RESOURCE_NAME,
        path='/',
        tags=tags,
    )

    group = iam.Group(
        RESOURCE_NAME,
        path='/',
    )

    iam.GroupMembership(
        RESOURCE_NAME,
        users=[user],
        group=group,
    )

    policy = json.dumps({
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
                    f"arn:aws:s3:::{deploy_bucket_name}",
                    f"arn:aws:s3:::{deploy_bucket_name}/*"
                ]
            }
        ]
    })

    iam_policy = iam.Policy(
        RESOURCE_NAME,
        path='/',
        policy=policy,
    )

    iam.GroupPolicyAttachment(
        RESOURCE_NAME,
        policy_arn=iam_policy.arn,
        group=group,
    )



