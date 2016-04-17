#!/usr/bin/env bash

src=$(basename $0)
src=${src#convert.}
src=${src%.sh}
tgt=${src#???????}
src=${src%???????}

if [ $# = 0 ]; then
  echo "usage: $(basename $0) <$src files>"
  exit 1
fi

for p in "${@}"; do
  j=${p%.$src}.$tgt
  echo "doing file: ${p}..."
  if [ -f "$j" ]; then
    echo "$tgt version already exist!!"
    continue
  fi
  'c:/Program Files/ImageMagick-6.9.0-Q16/convert' "${p}" "${j}"
  if [ ! -f "$j" ]; then
    echo "$tgt version was NOT created successfully!"
    continue
  fi
  rm "$p"
done
