#!/usr/bin/env bash

if [ $(basename $PWD) = shorts ]; then
  echo "ERROR: already in a 'shorts' directory!"
  exit 1
fi
                                 
inshorts=false

echo 'reading from stdin...'

while read file; do
  #file2="/cygdrive/t/recyclable/v${file#?}"
  case "$file" in
    t:/*) file="/cygdrive/t/${file#t:/}";;
  esac
  echo file=:$file:
  if [ ! -f "$file" ]; then
    echo
    echo "ERROR: unable to access file:"
    #echo "  t:/recyclable/v${file#?}"
    echo "  $file"
    exit 1
  fi
  
#  if [ $inshorts = false ]; then
#    echo -n "making shortcuts in 'shorts' "
#    mkdir -p shorts
#    cd shorts || echo "ERROR! cannot cd into 'shorts' dir!" && exit 1
#    inshorts=true
#  fi

  echo + mkshortcut.exe "$file"
         mkshortcut.exe "$file"
  echo -n '.'
done
