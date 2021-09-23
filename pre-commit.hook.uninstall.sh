#!/usr/bin/env bash

top=$(git rev-parse --show-toplevel)

if [ "$top" = "$HOME" ] ;then
  echo 'ERROR: not running on $HOME repo'
  exit 1
fi

cmd="rm $top/.git/hooks/pre-commit"
echo + $cmd ;eval   $cmd
cmd="rm $top/.pre-commit-config.yaml"
echo + $cmd ;eval   $cmd
