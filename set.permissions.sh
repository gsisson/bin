#!/usr/bin/env bash

if ! issuperuser ];then
  echo 1>&2
  echo 'must be run as admin' 1>&2
  echo 1>&2
  exit 1
fi

whoami=`whoami`
set -x
chown ${whoami}:None . -R
chmod 770            . -R
