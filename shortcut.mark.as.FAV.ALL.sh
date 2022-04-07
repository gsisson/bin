#!/usr/bin/env bash

for f in *lnk; do
  if [ "$f" != '*lnk' ]; then
    #echo
    end="${f##*#}"
    beg="${f%$end}"
    new_f="${beg}FAV#${end}"
    #echo "f $f"
    #echo :$beg:$end:
    case "$beg" in
      FAV#)   ;;
      *#FAV#) ;;
      *)      echo + mv "${f}" "${new_f}"
                #    mv "${f}" "${new_f}"
              ;;
    esac
  fi
done
