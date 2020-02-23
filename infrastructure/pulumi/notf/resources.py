import json

from pulumi_aws import resourcegroups

def create(project, tags):

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

    resourcegroups.Group(
        project,
        resource_query=resource_query,
        tags=tags
    )

