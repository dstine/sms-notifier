import json
from typing import Dict

from pulumi_aws import resourcegroups

def converge(project: str, tags: Dict[str, str]) -> None:

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

