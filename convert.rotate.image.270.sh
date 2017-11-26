#!/usr/bin/env bash

if [ $# = 0 ]; then
  echo "usage: $(basename $0) <image files to roate 270 degrees>"
  exit 1
fi

convert=convert
if [ -f 'c:/Program Files/ImageMagick/convert' ]; then
  convert='c:/Program Files/ImageMagick/convert'
fi

if [ ! -d out ]; then
  echo "directory out/ DNE!"
  exit 1
fi

for p in "${@}"; do
  # convert "$file" -rotate 90 "$file"_rotated.JPG
  echo + "$convert" "${p}" -background 'rgba(0,0,0,0)' -rotate 270 out/"${p}"
         "$convert" "${p}" -background 'rgba(0,0,0,0)' -rotate 270 out/"${p}"
done

