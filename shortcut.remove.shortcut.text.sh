#!/usr/bin/env bash

for f in *\ -\ Shortcut.lnk*; do
  if [ "$f" = '* - Shortcut.lnk*' ]; then
    echo "no files with ' - Shortcut.lnk' in them"
    exit
  fi
  newf=`echo "${f}"|sed -e 's: - Shortcut.lnk$:.lnk:'`
  if [ ! -f "$newf" ]; then
    echo + mv \"$f\" \"$newf\"
    mv "$f" "$newf"
  else
    echo "# FAIL: \"${newf}\" exists!"
  fi
done
