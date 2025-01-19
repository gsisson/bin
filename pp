#!/usr/bin/env bash
. ~/.bashrc

# MERGE WITH usr/bin/adobe !!!

case $(uname) in
  CYGWIN*) ;;
  *)       echo "not supported on this playform!"
	   exit 1;;
esac

cmd='C:/Program Files/Adobe/Adobe Premiere Pro CS6/Adobe Premiere Pro.exe'
cmd='C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Adobe Production Premium CS6/Adobe Premiere Pro CS6.lnk'
if [ ! -f "$cmd" ]; then
  echo "unable to find file: \"$cmd\""
  exit 1
fi

if [ $# == 0 ]; then
# echo + start "$cmd"
         start "$cmd" &
  exit
fi

# call abobe for each arg passed (can only open one file at a time)
for arg in "$@"; do
  arg=$(f2b $arg)
  case "$arg" in
    \\*|//*)   ;;
    [a-zA-Z]:*);;
    \*|/*)     ;;
    *)         arg=${PWD}/${arg}
               arg=$(cd $(dirname $arg);pwd)/$(basename $arg)
               arg=`cygdrivePathFix "$arg"`
               arg=`echo $arg | f2b`
               ;;
  esac
  if [ ! -f "$arg" ]; then
    echo "file does not exist: \"$arg\""
  fi
# echo + start "$cmd" -f "$arg"
         start "$cmd" -f "$arg" &
done
