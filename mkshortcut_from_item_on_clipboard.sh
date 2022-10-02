#!/usr/bin/env bash

echo >&2
echo >&2 "STOP - USE mkshortcut.sh instead!!!"
echo >&2
exit 1

# called from ????
#  => THIS SCRIPT
#    => mkshortcut.sh
#      => Powershell

usage() {
  echo >&2 "usage: $(basename $0) TARGET_DIR_FOR_SHORTCUT"
  echo >&2
  echo >&2 " note: be sure the path to the item (or items) is on the CLIPBOARD!"
  echo >&2
  exit 1
}

if [ $# = 0 -o "$1" = "" ]; then
  usage
fi

target_dir="$1"
if [ ! -d "$target_dir" ]; then
  echo >&2 -ne "\033[1;91mERROR: not a directory!\n  =>\033[0m"
  echo >&2 -ne "$target_dir"
  echo >&2  -e "\033[1;91m<=\033[0m"
  echo >&2
  usage
fi

case ${target_dir} in
  */) ;;
  *)  target_dir="${target_dir}/"
esac

items=`getclip|d2u`
if [ -z "$items" ]; then
  echo >&2 -e "\033[1;91mERROR: nothing on clipboard!\033[0m"
  echo >&2
  usage
fi

if [ -f "$items" -o -d "$items" ]; then
  item="$items"
  item_name="$(basename $item)"
  # echo + mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
           mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
else
  tmpf="t:/tmp/$(basename $0)_$$"
  trap "rm -f $tmpf" 0 2 3 15
  getclip|d2u >  $tmpf
  echo        >> $tmpf
  cat "$tmpf" | while read item; do
    if [ -z "$item" ]; then
        continue
    fi
    if [ ! -f "$item" ]; then
      echo >&2 -ne "\033[1;91mERROR: this is not a file (clipboard)!\n  =>\033[0m"
      echo >&2 -ne "$item"
      echo >&2  -e "\033[1;91m<=\033[0m"
      continue

    fi
    item_name="$(basename $item)"
    # echo + mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
             mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
  done
fi
