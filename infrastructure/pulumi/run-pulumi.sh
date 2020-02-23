#!/bin/bash

# https://www.pulumi.com/docs/reference/cli/environment-variables/
export PULUMI_CONFIG_PASSPHRASE=''
export PULUMI_HOME='.pulumi'
export PULUMI_SKIP_UPDATE_CHECK=true

PULUMI_VERSION=1.11.0
PULUMI=~/software/pulumi/pulumi-v${PULUMI_VERSION}/pulumi

AWS_PROFILE=terraform
export AWS_PROFILE=${AWS_PROFILE}

if [ -z $1 ]; then
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "Error in $DIR/`basename $0`:"
  echo "  Must set 1st argument to PULUMI_CMD"
  exit 1
else
  PULUMI_CMD=$1
fi

PULUMI_ARGS=${@:2}

CLI="${PULUMI} ${PULUMI_CMD} ${PULUMI_ARGS}"
echo ${CLI}
${CLI}

