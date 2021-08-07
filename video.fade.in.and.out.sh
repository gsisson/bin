#!/bin/bash

set -e
fade_duration=1

opts="-hide_banner -loglevel error"

if [ $# = 1 ]; then
  f="$(basename $1)"
  ext="${f##*.}"
  set -- "$1" "${f%.*}_FADE.${ext}"
fi

if [ $# != 2 ]; then
  echo "usage: ${0##*/} input-mp4 [output-mp4]"
  exit 1
fi

file_in="$1"
file_out="$2"
#echo file_in:$file_in
#echo file_out:$file_out

if [ "$file_in" = "$file_out" ]; then
  echo "ERROR: both arguments cannot be the same!"
  exit 1
fi

if [ ! -f "$file_in" ]; then
  echo "ERROR: file '${file_in}' not found!"
  exit 1
fi

if [ -f "$file_out" ]; then
  echo "ERROR: file '${file_out}' already exists!"
  exit 1
fi

for prog in bc awk ffprobe ffmpeg; do
  if ! type &>/dev/null $prog; then
    echo >&2 "'$prog' tool not found!"
    exit 1
  fi
done

clip_len=$(ffprobe -select_streams v -show_streams "${file_in}" 2>/dev/null |
  awk -F= '$1 == "duration"{print $2}' | col -b)
#echo "clip_len==${clip_len}=="
fade_out_start_pos=$(bc -l <<< "$clip_len - $fade_duration")
#echo "fade_out_start_pos==${fade_out_start_pos}=="

echo "creating '$fade_duration' sec fade in/out (out: ${file_out})..."

begg="$(dirname $1)/_begg_$(basename $1)"
midd="$(dirname $1)/_midd_$(basename $1)"
tail="$(dirname $1)/_tail_$(basename $1)"
beggF="$(dirname $1)/_begg_F_$(basename $1)"
tailF="$(dirname $1)/_tail_F_$(basename $1)"
echo "  cutting beginning segment..."
nice ffmpeg $opts                             -i "${file_in}" -to "${fade_duration}"      -c:v libx264 -crf 22 -preset veryfast -strict -2 "$begg"
echo "  cutting middle segment..."
#nice fmpeg $opts -ss "${fade_duration}"      -i "${file_in}" -to "${fade_out_start_pos}" -c:v libx264 -crf 22 -preset veryfast -strict -2 "$midd"
nice ffmpeg $opts -i "${file_in}" -ss "${fade_duration}"      -to "${fade_out_start_pos}" -c:v libx264 -crf 22 -preset veryfast -strict -2 "$midd"
echo "  cutting end segment..."
#fmpeg $opts -ss "${fade_out_start_pos}" -i "${file_in}"                             -c:v libx264 -crf 22 -preset veryfast -strict -2 "$tail"
nice ffmpeg $opts -i "${file_in}" -ss "${fade_out_start_pos}"                             -c:v libx264 -crf 22 -preset veryfast -strict -2 "$tail"

echo "  fadding in..."
nice ffmpeg $opts -i "$begg" -vf "fade=t=in:st=0:d=${fade_duration}"  -af 'afade=in:st=0:d=1'  "$beggF"
echo "  fading out..."
nice ffmpeg $opts -i "$tail" -vf "fade=t=out:st=0:d=${fade_duration}" -af 'afade=out:st=0:d=1' "$tailF"

echo "  concating pieces..."
     video.concat.sh "$beggF" "$midd" "$tailF" "${file_out}"

rm -f "$begg" "$tail" "$beggF" "$midd" "$tailF"
