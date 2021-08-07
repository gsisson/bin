#!/usr/bin/env bash

opts="-hide_banner -loglevel error"

cd ~/Downloads
tdir=t:/RECYCLABLE/v/new/__PATCHING

if [ ! "$(ls *mp4 2>/dev/null)" ]; then
  echo 'no *.mp4 files found in ~/Downloads'
  echo "but these were found in $tdir"
  eval ls -d "$tdir/*" | sed -e "s|$tdir/|  |"
  exit 0
fi

ls *mp4 2>/dev/null | sed -e 's:.mp4$::' -e 's:([0-9][0-9]*)$::' | sort -u | while read name; do
  echo "doing $name..."
  mkdir -p "$tdir/${name}/SRC"
  cd "$tdir/${name}/SRC"
  nnn=$(\ls -r | head -1)
  if [ "$nnn" = "" ]; then
    nnn="000"
  else
    nnn=${nnn%.mp4}
    nnn=${nnn%.DUP}
    nnn=${nnn##0}
    nnn=${nnn##0}
    nnn=${nnn##0}
    ((nnn++))
    nnn=`printf "%03s\n" $nnn`
  fi
  # echo "originals will be saved starting with $nnn"
  cd - > /dev/null
  for n in `seq -f "%g" 0 100` ; do
    if [ $n = 0 ]; then
      f="${name}.mp4"
    else
      f="${name}($n).mp4"
    fi
    if [ -f "$f" ]; then
      if [ "$(ls -A $tdir/${name}/SRC)" ]; then
        cd "$tdir/${name}/SRC"
        files=$(ls *mp4 | grep -v DUP)
        if [ "" != "$(sum $files | cut -c1-5 | sort | uniq -c |sort | grep -v '^ *1 [0-9]')" ]; then
          echo
          echo
          echo "unexpected duplicate checksums in $tdir/${name}/SRC/ !!"
          echo " EXITTING..."
          echo
          echo
          exit
        fi
        cd - > /dev/null
      fi
      sf="$tdir/${name}/SRC/${nnn}.mp4"
      tf="$tdir/${name}/${nnn}.mp4"
      mv "$f" "$sf" 2>&1 | grep -v 'mv: preserving permissions'
      cd $(dirname $sf)
      files=$(ls *mp4 | grep -v DUP)
      if [ "" != "$(sum $files | cut -c1-5 | sort | uniq -c |sort | grep -v '^ *1 [0-9]')" ]; then
        echo "  duplicate found in SRC/ (renaming ${nnn}.mp4 to ${nnn}.DUP.mp4)"
        mv "${nnn}.mp4" "${nnn}.DUP.mp4"
      else
        echo "  " ffmpeg $opts -i "${nnn}.mp4" -c:v libx264 -c:a aac "../${nnn}.mp4"...
                  ffmpeg $opts -i "${nnn}.mp4" -c:v libx264 -c:a aac "../${nnn}.mp4" > /dev/null 2>&1
      fi
      cd - > /dev/null
      nnn=${nnn##0}
      nnn=${nnn##0}
      nnn=${nnn##0}
      ((nnn++))
      nnn=`printf "%03s\n" $nnn`
    fi
  done
  echo "results in $tdir/${name}/"
  exit
done
