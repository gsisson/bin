#!/usr/bin/env bash

usage() {
  echo
  echo "USAGE: $(basename $0) -d <OUTPUT_DIRECTORY> <INPUT_MOV_FILE>..."
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
outdir="${outdir%/}"

for f in "${@}"; do
  case "$f" in
    *.mov) ;;
    *.MOV) ;;
    *)     echo ; echo "ERROR: \"$f\" is not an MOV file!";usage;;
  esac
done

for f in "${@}"; do
  f="${f%.mov}"
  f="${f%.MOV}"
  echo + ffmpeg -deinterlace -i "$f.mov" "$outdir/$f.mp4"
         ffmpeg -deinterlace -i "$f.mov" "$outdir/$f.mp4"
done
