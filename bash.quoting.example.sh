#!/usr/bin/env bash

echo
echo "#not surprisingly, this doesn't work:"
echo 'ls -d $(echo "c:/Program Files")'
ls -d $(echo "c:/Program Files")

echo
echo "#surprisingly, this does!  With this strange pairing of double quotes:"
echo 'ls -d "$(echo "c:/Program Files")"'
ls -d "$(echo "c:/Program Files")"

echo
