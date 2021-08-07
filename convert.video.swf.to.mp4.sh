#!/usr/bin/env bash

opts="-hide_banner -loglevel error"

usage() {
  echo
  echo "USAGE: $(basename $0) -d <OUTPUT_DIRECTORY> <INPUT_FILE>..."
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
    *.swf) ;;
    *)     echo ; echo "ERROR: \"$f\" is not an SWF file!";usage;;
  esac
done

for f in "${@}"; do
  f="${f%.swf}"
  echo + ffmpeg $opts -deinterlace -i "$f.swf" "$outdir/$f.mp4"
         ffmpeg $opts -deinterlace -i "$f.swf" "$outdir/$f.mp4"
done
