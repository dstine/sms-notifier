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

# TODO

* Custom resource to upload Lambda zip file
* Use Pulumi configuration feature
* Mark SMTP password as secret

