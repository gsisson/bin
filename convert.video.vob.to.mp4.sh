#!/usr/bin/env bash

opts="-hide_banner -loglevel error"

usage() {
  echo
  echo "USAGE: $(basename $0) -d <OUTPUT_DIRECTORY> <INPUT_VOB_FILE>..."
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
    *.VOB) ;;
    *.vob) ;;
    *)     echo ; echo "ERROR: \"$f\" is not an VOB file!";usage;;
  esac
done

for f in "${@}"; do
  f="${f%.vob}"
  echo + ffmpeg $opts -i "$f" -deinterlace -acodec copy "$outdir/$f.mp4"
         ffmpeg $opts -i "$f" -deinterlace -acodec copy "$outdir/$f.mp4"
done
