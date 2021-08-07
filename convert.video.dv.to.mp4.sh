#!/usr/bin/env bash

opts="-hide_banner -loglevel error"

usage() {
  echo
  echo "USAGE: $(basename $0) -d <OUTPUT_DIRECTORY> <INPUT_DV_FILE>..."
  echo
  exit 1
}

if [ $# -lt 3 -o "$1" != '-d' ]; then
  usage
fi

shift # -d
outdir="$1"
shift

if [ ! -d "$outdir" ]; then
  echo
  echo "ERROR: \"$outdir\" is not a directory!"
  usage
fi
outdir=${outdir%/}

for f in "${@}"; do
  case "$f" in
    *.dv) ;;
    *)     echo ; echo "ERROR: \"$f\" is not a DV file!";usage;;
  esac
done

for f in "${@}"; do
  f="${f%.dv}"
  echo + ffmpeg.exe $opts -i "$f.dv" -deinterlace -y -c:v libx264 -c:a aac -crf 22 -preset fast -pix_fmt yuv420p "$outdir/$f.mp4"
         ffmpeg.exe $opts -i "$f.dv" -deinterlace -y -c:v libx264 -c:a aac -crf 22 -preset fast -pix_fmt yuv420p "$outdir/$f.mp4"
done
