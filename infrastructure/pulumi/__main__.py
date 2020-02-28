import notf.resources
import notf.runtime

project = 'sms-notifier'

tags = {
    'project': project,
    'infra-tool': 'pulumi',
}

notf.resources.converge(project, tags)

notf.runtime.converge(tags)

