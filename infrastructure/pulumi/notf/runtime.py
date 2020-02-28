# Manages infrastructure for running application code
# A lambda function and associated resources

import json

import pulumi
import pulumi_aws as aws

from pulumi_aws import cloudwatch
from pulumi_aws import iam
from pulumi_aws import lambda_

import notf.config

REGION = 'us-east-1'
ACCOUNT_ID = aws.get_caller_identity().account_id
RESOURCE_NAME = 'sms-notf-run-pulumi'


def create(tags):

    log_group_name = _create_cloudwatch_log_group(tags)
    role = log_group_name.apply(lambda lgn: _create_iam(lgn, tags))

    lambda_fn = _create_lambda(role, tags)

    for trigger in notf.config.TRIGGERS:
        _create_trigger(trigger, lambda_fn, tags)


def _create_cloudwatch_log_group(tags):

    log_group = cloudwatch.LogGroup(
        f'/aws/lambda/{RESOURCE_NAME}',
        tags=tags
    )

    return log_group.name


def _create_iam(log_group_name, tags):

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
                    f"arn:aws:logs:{REGION}:{ACCOUNT_ID}:log-group:{log_group_name}:*"
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

    iam_policy = iam.Policy(
        RESOURCE_NAME,
        path='/',
        policy=policy)

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

    role = iam.Role(
        RESOURCE_NAME,
        assume_role_policy=assume_role_policy,
        tags=tags
    )

    role_policy_attachment = iam.RolePolicyAttachment(
        RESOURCE_NAME,
        policy_arn=iam_policy.arn,
        role=role
    )

    return role


def _create_lambda(role, tags):

    lambda_fn = lambda_.Function(
        RESOURCE_NAME,
        role=role.arn,
        handler="com.github.dstine.sms.SmsHandler::handleRequest",
        runtime="java8",
        memory_size="256",
        timeout="60",
        code="../../build/distributions/sms-notifier.zip", # TODO: better path computation
        environment = {
            'variables': {
                'SMTP_HOST':     notf.config.SMTP_HOST,
                'SMTP_USERNAME': notf.config.SMTP_USERNAME,
                'SMTP_PASSWORD': notf.config.SMTP_PASSWORD,
                'EMAIL_SUBJECT': notf.config.EMAIL_SUBJECT,
                'EMAIL_FROM':    notf.config.EMAIL_FROM,
                'EMAIL_TO':      notf.config.EMAIL_TO,
            }
        },
        tags=tags,
    )
    return lambda_fn


def _create_trigger(trigger, lambda_fn, tags):

    id = trigger['id']
    event_name = f'{RESOURCE_NAME}-{id}'
    event_rule = cloudwatch.EventRule(
        event_name,
        schedule_expression=trigger['schedule'],
        tags=tags,
    )

    event_target = cloudwatch.EventTarget(
        event_name,
        rule=event_rule,
        target_id=lambda_fn.name,
        arn=lambda_fn.arn,
        input=trigger['input'],
    )

    lambda_.Permission(
        event_name, # RESOURCE_NAME?
        statement_id=event_name,
        action="lambda:InvokeFunction",
        function=lambda_fn,
        principal="events.amazonaws.com",
        source_arn=event_rule.arn,
    )

