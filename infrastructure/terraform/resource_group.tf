resource "aws_resourcegroups_group" "group" {
  name = "sms-notifier"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "project",
      "Values": ["sms-notifier"]
    }
  ]
}
JSON
  }

  tags = {
    project   = "sms-notifier"
    terraform = true
  }
}

