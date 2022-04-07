#!/usr/bin/env bash

usage() {
  echo >&2 "usage: $(basename $0) TARGET_DIR_FOR_SHORTCUT"
  echo >&2
  echo >&2 " note: be sure the path to the item (or items) is on the CLIPBOARD!"
  echo >&2
  exit 1
}

target_dir="$1"
if [ ! -d "$target_dir" ]; then
  echo >&2 "ERROR: not a directory: '$target_dir'!"
  echo >&2
  usage
fi

case ${target_dir} in
  */) ;;
  *)  target_dir="${target_dir}/"
esac

items=`getclip|d2u`
if [ -z "$items" ]; then
  echo >&2 "ERROR: nothing on clipboard!"
  echo >&2
  usage
fi

if [ -f "$items" -o -d "$items" ]; then
  item="$items"
  item_name="$(basename $item)"
  echo + mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
         mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
else
  tmpf="t:/tmp/$(basename $0)_$$"
  trap "rm -f $tmpf" 0 2 3 15
  getclip|d2u>$tmpf
  cat "$tmpf" | while read item; do
    if [ -z "$item" ]; then
        continue
    fi
    item_name="$(basename $item)"
    echo + mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
           mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
  done
fi
