# Manages infrastructure for running application code
# A lambda function and associated resources

import json

import pulumi
from pulumi_aws import iam
from pulumi_aws import s3

import notf.config

RESOURCE_NAME = 'sms-notf-deploy-pulumi'


def create(tags):

    deploy_bucket_name = _create_s3(tags)
    # TODO: upload Java code via dynamic provider
    deploy_bucket_name.apply(lambda dbn: _create_iam(dbn, tags))
    return deploy_bucket_name


def _create_s3(tags):

    bucket = s3.Bucket(
        RESOURCE_NAME,
        acl='private',
        force_destroy=True,
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

    pulumi.export('bucket_name', bucket.bucket)
    deploy_bucket_name = bucket.bucket
    return deploy_bucket_name


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



