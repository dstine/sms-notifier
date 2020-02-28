import notf.resources
import notf.runtime

# Terraform-managed project is 'sms-notifier'
project = 'sms-notifier-pulumi'

tags = {
    'project': project,
    'infra-tool': 'pulumi',
}

notf.resources.converge(project, tags)

notf.runtime.converge(tags)

