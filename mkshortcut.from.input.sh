#!/usr/bin/env bash

if [ $(basename $PWD) = shorts ]; then
  echo "ERROR: already in a 'shorts' directory!"
  exit 1
fi
                                 
inshorts=false

echo 'reading from stdin...'
while read file; do
#  echo file:/cygdrive/t/recyclable/v${file#?}
  file2="/cygdrive/t/recyclable/v${file#?}"
  if [ ! -f "$file2" ]; then
    echo
    echo "ERROR: unable to access file:"
    echo "  t:/recyclable/v${file#?}"
    exit 1
  fi
  
  if [ $inshorts = false ]; then
    echo -n "making shortcuts in 'shorts' "
    mkdir -p shorts
    cd shorts || echo "ERROR! cannot cd into 'shorts' dir!" && exit 1
    inshorts=true
  fi

  mkshortcut.exe "$file2"
  echo -n '.'
done
