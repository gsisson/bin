#!/usr/bin/env bash

src=$(basename $0)

src=${src#convert.image.}
src=${src%\.sh}       # remove suffix .sh
src=${src%\.set\.dto} # remove suffix .set.dto

tgt="$src"
src=${src%\.????} # remove 4 letter extension like .heic
src=${src%\.???}  # remove 3 letter extension like .jpg
src=${src%\.to}

tgt=${tgt#$src}
tgt=${tgt#\.to\.}

case ${0} in
  *set.dt*) setdatetime=true;;
  *)        setdatetime=false;;
esac

if [ $# = 0 ]; then
  echo "usage: $(basename $0) <$src files>"
  exit 1
fi

err=""
for p in "${@}"; do
  j=${p%.$src}.$tgt
  if [ ! -f "$p" ]; then
    echo -e "\033[1;31mERROR: '$p' does NOT exist!\033[0m"
    err="true"
  fi
  if [ -f "$j" ]; then
    echo -e "\033[1;31mERROR: '$j' already exists!\033[0m"
  fi
done
if [ "$err" = true ]; then
  exit 1
fi

for p in "${@}"; do
  j=${p%.$src}.$tgt
  echo "doing file: ${p}..."
  convert=convert
  if [ -f 'c:/Program Files/ImageMagick/convert' ]; then
    convert='c:/Program Files/ImageMagick/convert'
  fi
  if [ -f '/opt/homebrew/bin/convert' ]; then
    convert='/opt/homebrew/bin/convert'
  fi
  if [ ! -f "$convert" ]; then
    echo -e "\033[1;31mERROR: Cannot find 'convert' program!\033[0m"
    echo "       Maybe when ImageMagick was installed you forgot to"
    echo "       check the 'install legacy programs?' checkbox?"
    exit 1
  fi
  echo "starting..."
  echo -e "+ \033[0;32m$convert" "${p}" "${j}\033[0m"
  "$convert" "${p}" "${j}"
  echo "done..."
  if [ ! -f "$j" ]; then
    echo -e "\033[1;31m$tgt version was NOT created successfully!\033[0m"
    continue
  fi
  rm "$p"
  if [ "$setdatetime" = true ]; then
    exif.set.DateTimeOriginal.from.filename.rb "$j"
    if [ ! -f "${j}_original" ]; then
      echo -e "\033[1;31mexif failed!\033[0m"
      continue
    fi
    rm "${j}_original"
  fi
done
