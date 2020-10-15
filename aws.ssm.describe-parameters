#!/usr/bin/env bash

echo -n "SMS parameters for account: "
aws sts get-caller-identity | grep 'Account' | sed -e 's:",$::' -e 's:.*"::'

aws ssm describe-parameters | grep "Name"
