#!/usr/bin/env bash

# this file is used by ~/usr/completion/e

set -- "${1,,}"

# This script is
#   ~/usr/bin/e
#
# It provides command completion when used in conjuction
#   with ~/usr/completion/e
#
# Pass an argument and when runs it will 'edit' the passed argument

# - Here we handle the supported 'shorthand' arguements for things to be editted
# - Add more entries to the 'case' to handle new shorthands for things to edit
# - Any argument that isn't a shorthand will show a list of supported shorthands

case "$1" in
  auto_hot_key)     efile $HOME/usr/bin/config/AutoHotkey.ahk;;
  dot.emacs)        if [ -d "C:/Windows" ];then
                      efile "$HOME/My Documents/Cloud/Dropbox/=SHARED_from.Glenn.to.Nomad/lisp/dot.emacs"
                    else
                      efile "$HOME/Dropbox/=SHARED_from.Glenn.to.Nomad/lisp/dot.emacs"
                    fi;;
  -?)               cat $0 | grep -v '^#' | grep '[a-z])' | sed -e 's:).*::' -e 's:^  ::' | column;;
  *) echo "Unknown option: \"$prog\""
     echo "Try one of these:"
     $0 -? | expand | sed -e 's:^:  :';;
esac
