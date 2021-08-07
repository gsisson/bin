#!/usr/bin/env bash

opts="-hide_banner -loglevel error"

if [ $# != 2 ]; then
  echo "usage: $(basename $0) <video-to-rotate> <output-video-file>"
  echo "   ex: $(basename $0) upside-down-video.mp4 right-side-up-output-video.mp4"
  exit 1
fi

infile="$1"
if [ ! -f "${infile}" ]; then
  echo "ERROR: input file '${infile}' does not exist!"
  exit 1
fi

outfile="$2"
if [ -f "${outfile}" ]; then
  echo "ERROR: output file '${outfile}' exists!"
  exit 1
fi

echo + ffmpeg $opts -i "$infile" -vf hflip,vflip,format=yuv420p -metadata:s:v rotate=0 -codec:v libx264 -codec:a copy "$outfile"
       ffmpeg $opts -i "$infile" -vf hflip,vflip,format=yuv420p -metadata:s:v rotate=0 -codec:v libx264 -codec:a copy "$outfile"
