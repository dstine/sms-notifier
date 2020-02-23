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
    pulumi.export('bucket_suffix', bucket.bucket.apply(lambda b: b.split('-')[-1]))
    deploy_bucket_name = bucket.bucket
    return deploy_bucket_name


