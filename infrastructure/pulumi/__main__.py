import notf.resources
import notf.runtime

# Terraform-managed project is 'sms-notifier'
project = 'sms-notifier-pulumi'

tags = {
    'project': project,
    'infra-tool': 'pulumi',
}

notf.resources.create(project, tags)

notf.runtime.create(tags)

