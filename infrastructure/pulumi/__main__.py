import notf.config
import notf.deploytime
import notf.resources
import notf.runtime

# Terraform-managed project is 'sms-notifier'
project = 'sms-notfier-pulumi'

tags = {
    'project': project,
    'infra-tool': 'pulumi',
}

notf.resources.create(project, tags)

deploy_bucket_name = notf.deploytime.create(tags)

notf.runtime.create(deploy_bucket_name, tags)

