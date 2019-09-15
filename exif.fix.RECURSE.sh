#!/usr/bin/env bash

tmpf="$PWD/exif.fix.sh"

if [ -f "$tmpf" ];then
  echo "file \"$(basename $tmpf)\" exists!  stopping..."
  exit 1
fi

if find . -type d | grep \' ; then
  echo "found dirs with quotes in them!  Please fix!"
  exit 1
fi

if find . -type f | egrep -i '(jpg|jpeg)' | grep \' ; then
  echo "found files with quotes in them!  Please fix!"
  exit 1
fi

echo "p=\"$PWD\"" >> $tmpf
find . -type d |
while read d
do
  if [ ! -d "$d" ];then
    continue
  fi
  cd "$d" > /dev/null
  status=99
  while [ $status = 42 -o $status = 99 ]; do
    if [ $status = 42 ]; then
      echo -n '+' 1>&2      
    else
      echo -n . 1>&2
    fi
    echo '=======================================================================' >> $tmpf
    echo 'cd "$p"; cd "'$d'"' >> $tmpf
  # exif.fix.rb | tee -a "$tmpf"
    exif.fix.rb >> "$tmpf" 2>&1
    status=$?
    if [ $status != 0 -a $status != 42 ]; then
      echo -n 'X' 1>&2      
    fi
  done
  cd - > /dev/null
done
