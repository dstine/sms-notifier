# Setup

Store state in `{CWD}/.pulumi`:
```
$ ./run-pulumi.sh login file://.
```

Install Pulumi AWS provider:
```
$ ./run-pulumi.sh plugin install resource aws v1.23.0
```

Create Python virtual environment:
```
$ python3 -m venv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
```

# Manage Infrastructure

Configure notification schedules:
`notf/config.py`
```
import json

from notf.util.time_utils import to_utc

SMTP_HOST            = "email-smtp.us-east-1.amazonaws.com"
SMTP_USERNAME        = "TODO:
SMTP_PASSWORD        = "TODO"
EMAIL_SUBJECT        = "Pulumi"
EMAIL_FROM           = "TODO"
EMAIL_TO             = "TODO"

TRIGGERS = [
    {
        'id': 'Jeopardy',
        'schedule': f"cron({to_utc('19:20')} ? * MON-SAT *)",
        'input': json.dumps({"msgFormat": "%s: Jeopardy!"}),
    },
]

```


Development loop:
```
$ ./run-pulumi.sh preview
$ ./run-pulumi.sh up
```

# TODO

* Use Pulumi configuration feature
* Mark SMTP password as secret
* Use custom component
* Use Lambda Layer for libraries

