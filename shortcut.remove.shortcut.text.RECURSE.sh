#!/usr/bin/env bash
. ~/.bash_profile

find . -type d | while read d; do
  cd "$d" ; echo $d | grep .
  shortcut.remove.shortcut.text.sh 
  cd - >/dev/null
done
