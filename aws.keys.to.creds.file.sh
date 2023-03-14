#!/usr/bin/env bash

pbpaste | grep -i AWS_SESSION_TOKEN >/dev/null
if [ $? != 0 ] ; then
  if [[ "$1" =~ [0-9]* ]]; then
    :
  else
    echo "clipboard doesn't appear to contain credentials!"
    exit 1
  fi
fi

if [ "$AWS_REGION" = "" ]; then
  echo "AWS_REGION is not set in the environment!"
  exit 1
fi

if [ "$AWS_PROFILE" = "" ]; then
  echo "AWS_PROFILE is not set in the environment!"
  exit 1
fi

line_no=`grep -n $AWS_PROFILE ~/.aws/credentials | cut -f1 -d:`
let "line_no=line_no+1"
if [ $? != 0 ] ; then
  echo "~/.aws/credentials does not have a profile section [$AWS_PROFILE]!"
  exit 1
fi

pbpaste | sed \
  -e 's|export AWS_ACCESS_KEY_ID="\(.*\)"|aws_access_key_id=\1|' \
  -e 's|export AWS_SECRET_ACCESS_KEY="\(.*\)"|aws_secret_access_key=\1|' \
  -e 's|export AWS_SESSION_TOKEN="\(.*\)"|aws_session_token=\1|' | pbcopy

vi +0$line_no ~/.aws/credentials

echo + aws s3 ls
       aws s3 ls || exit 1

iterm-set-tab-color-red() {
  echo -ne "\033]6;1;bg;red;brightness;255\a\033]6;1;bg;blue;brightness;0\a\033]6;1;bg;green;brightness;0\a"
}
iterm-reset-tab-color() {
  echo -ne "\033]6;1;bg;*;default\a"
}

iterm-set-tab-name() {
  echo -ne "\033]0;$@\007"
}

iterm-reset-tab-color

time=59
if [ -n "$1" ] ; then
  time=$1
fi 
while : ; do
  aws s3 ls > /dev/null || iterm-set-tab-color-red
  aws s3 ls > /dev/null || echo "CREDENTIALS EXPIRED!!"
  let "time=time-1"
  echo "time left: $time min"
  iterm-set-tab-name "⏰ ⏰ $time minutes left ⏰ ⏰"
  if [ "$time" -lt 15 ]; then
    break
  fi
  sleep 60
done

while : ; do
  for i in 1 2 3 4 5; do
    for j in 1 2 3 4 5 6; do
      iterm-set-tab-color-red
      sleep 1
      iterm-reset-tab-color
      sleep 1
    done
  done
  let "time=time-1"
  echo "time left: $time min"
  iterm-set-tab-name "⏰ ⏰ $time minutes left ⏰ ⏰"
done

