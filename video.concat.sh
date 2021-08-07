#!/usr/bin/env bash

opts="-hide_banner -loglevel error -noautorotate"
opts="-hide_banner -loglevel error"

if [ $# -lt 2 ]; then
  echo "usage: $(basename $0) <list-of-video-files-to-concat> <output-video-file>"
  echo "   ex: $(basename $0) file1.mpg file2.mpg output.mpg"
  exit 1
fi

outfile="${@: -1}"
if [ -f "${outfile}" ]; then
  echo "ERROR: output file '${outfile}' exists!"
  exit 1
fi

#echo :${@}:
args=(${*})
#echo :${args[@]}:
unset args[${#args[@]}-1]

for f in "${args[@]}"; do
  if [ "$f" = "$outfile" ]; then
    echo "ERROR: output file '$outfile' cannot also be an input file!"
    exit 1
  fi
done

for f in "${args[@]}"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: input file '$f' not found!"
    exit 1
  fi
done

for f in "${args[@]}"; do
  echo "file '${f}'"
done > tmp.file.list.txt

echo + ffmpeg $opts -f concat -safe 0 -i tmp.file.list.txt -c copy "$outfile"
  nice ffmpeg $opts -f concat -safe 0 -i tmp.file.list.txt -c copy "$outfile"

rm tmp.file.list.txt
