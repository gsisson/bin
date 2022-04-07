#!/usr/bin/env bash

usage() {
  echo >&2 "usage: $(basename $0) SHORTCUT_TO_CREATE TARGET"
  echo >&2 "   ex: $(basename $0) 'C:/tmp/my-new-shortcut-1.lnk' 'c:/tmp/my-existing-file.txt'"
  echo >&2 "   ex: $(basename $0) 'c:\tmp\my-new-shortcut-2' 'C:\tmp\my-exiting-file.txt'"
  echo >&2 "   ex: $(basename $0) 'c:\tmp\'                  'C:\tmp\my-exiting-file.txt'"
 #echo >&2 "   ex: $(basename $0) 'c:/tmp/go-google.lnk' 'http://google.com'"
  exit 1
}

if [ $# != 2 ]; then
  usage
fi

shortcut="$1"
target="$2"

if [ -z "$shortcut" ]; then
  echo >&2 "ERROR: shortcut is blank!"
  usage
fi

if [ -z "$target" ]; then
  echo >&2 "ERROR: target directory is blank!"
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

echo if [ -f "$shortcut" ]
if [ -f "$shortcut" ]; then
  echo >&2 "ERROR: shortcut already exists!"
  exit 1
fi

echo shortcut:$shortcut:
echo target:$target:

powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile \
  -Command '$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut("'$shortcut'"); $S.TargetPath = "'$target'"; $S.Save()'
