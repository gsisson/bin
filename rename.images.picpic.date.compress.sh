#!/usr/bin/env bash

# 2018-03-03_20-43-42_001.jpg
if [ "$#" = '0' ]
then
  set -- *
fi
for f in "${@}"; do
  case $f in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9].jpg)
      echo + mv "$f" "$(echo $f | sed -e 's/-//g' -e 's/_//g')"
             mv "$f" "$(echo $f | sed -e 's/-//g' -e 's/_//g')"
      ;;
  esac
done
