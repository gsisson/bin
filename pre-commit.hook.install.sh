#!/usr/bin/env bash

top=$(git rev-parse --show-toplevel)

cmd="cp ~/.git/hooks/pre-commit $top/.git/hooks/pre-commit"
echo + $cmd ;eval   $cmd
cmd="cp ~/.pre-commit-config.yaml $top/"
echo + $cmd ;eval   $cmd
