#!/usr/bin/env bash

if [ $# != 1 ]; then
  echo "$(basename $0) SSM_PARAMETER_NAME"
  exit 1
fi

echo -n "SMS parameters for account: "
aws sts get-caller-identity | grep 'Account' | sed -e 's:",$::' -e 's:.*"::'

aws ssm delete-parameter --name "${@}" | cat 
