#!/usr/bin/env bash

# these can be find in the registry in
#   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{****-****}

set -- "${1,,}"

case "$1" in
  auto_hot_key)     efile $HOME/usr/bin/config/AutoHotkey.ahk;;
  -?)               cat $0 | grep -v '^#' | grep '[a-z])' |
                    sed -e 's:).*::' -e 's:^  ::' | egrep -v -- '(\*|\-\?)' | column;;
  *) echo "Unknown option: \"$prog\""
     echo "Try one of these:"
     $0 -? | expand | sed -e 's:^:  :'
esac
