#!/usr/bin/env bash

shortcut="$1"
target="$2"

usage() {
  echo "usage: $(basename $0) SHORTCUT_NAME TARGET"
  echo "   ex: $(basename $0) 'c:/tmp/go-google.lnk' 'http://google.com'"
  exit 1
}

if [ -z "$shortcut" -o -z "$target" ]; then
  usage
fi

case $shortcut in
  *.lnk) continue;;
  *) shortcut="$shortcut.lnk"
esac

powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile \
  -Command '$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut("'$shortcut'"); $S.TargetPath = "'$target'"; $S.Save()'
