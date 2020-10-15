#!/usr/bin/env bash

if [ $# != 1 ]; then
  echo "$(basename $0) SSM_PARAMETER_NAME"
  exit 1
fi

aws sts get-caller-identity | grep 'Account'

aws ssm get-parameter --name /tlz/accounts --with-decryption | jq '.Parameter.Value' | sed -e 's:\\":":g' -e 's:^"::' -e 's:"$::' |jq
