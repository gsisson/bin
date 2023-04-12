#!/usr/bin/env bash

if [ $# != 1 ]; then
  echo "$(basename $0) SSM_PARAMETER_NAME"
  exit 1
fi

echo -n "SMS parameters for account: "
aws sts get-caller-identity | grep 'Account' | sed -e 's:",$::' -e 's:.*"::'

aws ssm get-parameter --name "${@}" --with-decryption | jq '.Parameter.Value' | sed -e 's:\\":":g' -e 's:^"::' -e 's:"$::' |jq
