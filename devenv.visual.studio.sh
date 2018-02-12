#!/usr/bin/env bash
. ~/.bashrc

de2012='C:/Program Files (x86)/Microsoft Visual Studio 11.0/Common7/IDE/devenv.exe' #2012
de2015='C:/Program Files (x86)/Microsoft Visual Studio 14.0/Common7/IDE/devenv.exe' #201?
de2017='c:/Program Files (x86)/Microsoft Visual Studio/2017/Professional/Common7/ide/devenv.exe'

for cmd in "$de2017" "$de2015" "$de2012"
do
  if [ -f "$cmd" ]; then
    #nohup "$cmd" "$@" >> $HOME/nohup.out 2>&1  &
    start "$cmd" $@ &
    exit
  fi
done
echo "could not find the IDE!!"