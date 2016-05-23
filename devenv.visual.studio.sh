#!/usr/bin/env bash
. ~/.bashrc

cmd='C:/Program Files (x86)/Microsoft Visual Studio 11.0/Common7/IDE/devenv.exe' #2012

#nohup "$cmd" "$@" >> $HOME/nohup.out 2>&1  &
 start "$cmd" $@ &
