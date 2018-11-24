#!/usr/bin/env bash
shortcut='C:\users\gsisson\test.lnk'
shortcut='test.lnk'
shortcut="$1"
target='http://google.com'
target="$2"

usage() {
  echo "usage $(basename $0): SHORTCUT_NAME TARGET"
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
