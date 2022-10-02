#!/usr/bin/env bash

# called from ????
#  => called by mkshortcut_from_item_on_clipboard.sh
#    => THIS SCRIPT
#      => Powershell

usage() {
  echo >&2 ""
  echo >&2 "usage: $(basename $0)                         TARGET_DIR"
  echo >&2 "       $(basename $0) SHORTCUT_TO_CREATE      TARGET_SHORTCUT"
  echo >&2 ""
  echo >&2 " - with two args, the shortcut will be created pointing to the target"
  echo >&2 "   - ex: $(basename $0) 'C:/tmp/shortcut-1.lnk' 'c:/tmp/file-1.txt'"
  echo >&2 "   - ex: $(basename $0) 'c:\tmp\shortcut-2'     'C:\tmp\file-2.txt'"
  echo >&2 "   - ex: $(basename $0) 'c:\tmp\'               'C:\tmp\file-3.txt'"
  echo >&2 "   - ex: $(basename $0) 'c:\tmp\'               'C:\tmp\file-3.txt'"
  echo >&2 ""
  echo >&2 " - with one arg, the clipboard is expected to contain one or more lines,"
  echo >&2 "   each a full path to a target, and shortcuts to each of those targets"
  echo >&2 "   will be created in the TARGET_DIR directory"
  echo >&2 "   - ex: $(basename $0) . # creates shortcuts in current directory"
  echo >&2 ""
  exit 1
}

mkshortcut_fn() {
  shortcut="$1"
  target="$2"

  if [ -z "$shortcut" ]; then
    echo >&2 -e "\033[1;91mERROR: shortcut is blank!\033[0m"
    usage
  fi

  if [ -z "$target" ]; then
    echo >&2 -e "\033[1;91mERROR: target directory is blank!\033[0m"
    usage
  fi

  if [ -d "$shortcut" ]; then
    shortcut="${shortcut%/}"
    shortcut="${shortcut}/$(basename $target).lnk"
  else
    if [ "${shortcut%lnk}" = "${shortcut}" ]; then
      shortcut="${shortcut}.lnk"
    fi
  fi

  # echo if [ -f "$shortcut" ]
  if [ -f "$shortcut" ]; then
    echo >&2 -e "\033[1;91mERROR: shortcut already exists!\033[0m"
    exit 1
  fi

  # echo >&2 shortcut:$shortcut:
    echo >&2 created $target

  powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile \
    -Command '$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut("'$shortcut'"); $S.TargetPath = "'$target'"; $S.Save()'
}


if [ $# = 0 -o "$1" = "" -o $# -gt 2 ]; then
  usage
fi

if [ $# = 2 ]; then
  mkshortcut_fn "$1" "$2"
else
  target_dir="$1"
  # handle case of clipboard containing list of target file items
  # to be shortcut'd into $target_dir
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
      #   echo + mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
      #          mkshortcut.sh "${target_dir}${item_name}.lnk" "${item}"
      mkshortcut_fn "${target_dir}${item_name}.lnk" "${item}"
    done
  fi
  exit
fi
