# Manages infrastructure for running application code
# A lambda function and associated resources

import json
import os
from typing import Dict

import pulumi
import pulumi_aws as aws

from pulumi import Output
from pulumi_aws import cloudwatch
from pulumi_aws import iam
from pulumi_aws import lambda_

import notf.config

REGION = 'us-east-1'
ACCOUNT_ID = aws.get_caller_identity().account_id
RESOURCE_NAME = 'sms-notf'
CODE_PROJECT_HOME = '../../'


def converge(
        tags: Dict[str, str]
        ) -> None:

    log_group_name = _converge_cloudwatch_log_group(tags)
    role = log_group_name.apply(lambda lgn: _converge_iam(lgn, tags))

    lambda_fn = _converge_lambda(role, tags)

    for trigger in notf.config.TRIGGERS:
        _converge_trigger(trigger, lambda_fn, tags)


def _converge_cloudwatch_log_group(
        tags: Dict[str, str]
        ) -> Output[str]:

    log_group = cloudwatch.LogGroup(
        f'/aws/lambda/{RESOURCE_NAME}',
        tags=tags
    )

    pulumi.export('log_group_name', log_group.name)

    return log_group.name


def _converge_iam(
        log_group_name: Output[str],
        tags: Dict[str, str]
        ) -> iam.Role:

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

    pulumi.export('role', role.name)

    return role


def _converge_lambda(
        role: iam.Role,
        tags: Dict[str, str],
        ) -> lambda_.Function:

    code_path = os.path.join(CODE_PROJECT_HOME, 'build/distributions', 'sms-notifier.zip')

    lambda_fn = lambda_.Function(
        RESOURCE_NAME,
        role=role.arn,
        handler="com.github.dstine.sms.SmsHandler::handleRequest",
        runtime="java8",
        memory_size="256",
        timeout="60",
        code=code_path,
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

    pulumi.export('lambda_name', lambda_fn.name)

    return lambda_fn


def _converge_trigger(
        trigger: Dict[str, str],
        lambda_fn: lambda_.Function,
        tags: Dict[str, str],
        ) -> None:

    id = trigger['id']
    event_name = f'{RESOURCE_NAME}-{id}'
    cron_expression = trigger['schedule']

    event_rule = cloudwatch.EventRule(
        event_name,
        schedule_expression=cron_expression,
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

    pulumi.export(event_name, cron_expression)

