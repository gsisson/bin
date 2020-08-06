#!/usr/bin/env bash
echo BASH_VERSION:$BASH_VERSION
echo ZSH_VERSION:$ZSH_VERSION
echo KSH_VERSION:$KSH_VERSION
echo version:$version
echo '$0:'$0
echo -n 'ps -o args= -p $$:'
ps -o args= -p "$$" | egrep -m 1 -o '\w{0,5}sh'
