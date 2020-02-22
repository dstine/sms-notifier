import json

import pulumi

from pulumi_aws import resourcegroups

import notf.runtime

# Terraform-managed project is 'sms-notifier'
project = 'sms-notfier-pulumi'

tags = {
    'project': project,
}

resource_query = {
    'query': json.dumps({
        "ResourceTypeFilters": [
            "AWS::AllSupported"
        ],
        "TagFilters": [
            {
                "Key": "project",
                "Values": [project]
            }
        ]
    })
}

resourcegroups.Group(project, resource_query=resource_query, tags=tags)

notf.runtime.create_iam(tags)

