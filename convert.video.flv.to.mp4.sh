#!/usr/bin/env bash

opts="-hide_banner -loglevel error"

echo "ffmpeg $opts -i input.flv -c copy -copyts output.mp4"

exit

src=$(basename $0)
src=${src#convert.}
src=${src%.sh}
src=${src%.dto}
src=${src%.set}
tgt=${src#???????}
src=${src%???????}

case ${0} in
  *set.dt*) setdatetime=true;;
  *)        setdatetime=false;;
esac

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
  convert=convert
  if [ -f 'c:/Program Files/ImageMagick/convert' ]; then
    convert='c:/Program Files/ImageMagick/convert'
  fi
  "$convert" "${p}" "${j}"
  if [ ! -f "$j" ]; then
    echo "$tgt version was NOT created successfully!"
    continue
  fi
  rm "$p"
  if [ "$setdatetime" = true ]; then
    exif.set.DateTimeOriginal.from.filename.rb "$j"
    if [ ! -f "${j}_original" ]; then
      echo "exif failed!"
      continue
    fi
    rm "${j}_original"
  fi
done
