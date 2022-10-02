#!/usr/bin/env bash

# called from many dirs
#  => findshortcuts
#    => THIS SCRIPT
#      => Cywin/mkshortcut.exe
#         [makes shortcut in CWD]

if [ $(basename $PWD) = shorts ]; then
  echo "ERROR: already in a 'shorts' directory!"
  exit 1
fi
                                 
inshorts=false

echo 'reading from stdin...'

while read file; do
  case "$file" in
    t:/*) file="/cygdrive/t/${file#t:/}";;
  esac
  echo file=:$file:
  if [ ! -f "$file" ]; then
    #echo 1>&2
    #echo 1>&2 "WARNING: ignoring non-file:" # (directories, probably)
    #echo 2>&2 "  $file"
    continue
  fi
  
  echo + mkshortcut.exe "$file"
         mkshortcut.exe "$file"
  echo -n '.'
done
