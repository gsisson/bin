#!/usr/bin/env bash
. ~/.bashrc

echo -n "looking for dots in clipboard..."

while :
do
  if [[ "`p`" =~ \. ]]; then
    echo
    echo -n "  found dots... changing to spaces..."
    p | sed -e 's:\.: :g' | c
    echo " done."
    echo "looking..."
  else
    echo -n "."
  fi
  sleep 1
done

