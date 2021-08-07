#!/usr/bin/env bash

opts="-hide_banner -loglevel error"

usage() {
  echo
  echo "USAGE: $(basename $0) -d <OUTPUT_DIRECTORY> <INPUT_AVI_FILE>..."
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
    *.avi) ;;
    *)     echo ; echo "ERROR: \"$f\" is not an AVI file!";usage;;
  esac
done

for f in "${@}"; do
  f="${f%.avi}"
  echo + ffmpeg $opts -deinterlace -i "$f.avi" "$outdir/$f.mp4"
         ffmpeg #opts -deinterlace -i "$f.avi" "$outdir/$f.mp4"
done
