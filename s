#!/usr/bin/env bash
. ~/.bashrc

#set -- "${1,,}"
cmd="$1"
shift

case "$cmd" in
  photoshop)        $HOME/usr/bin/adobe "$@";;
  premiere.pro)     $HOME/usr/bin/pp    "$@";;
  -?)               cat $0 | grep -v '^#' | grep '[a-z])' |
                    sed -e 's:).*::' -e 's:^  ::' | egrep -v -- '(\*|\-\?)' | column;;
  *) echo "Unknown option: \"$prog\""
     echo "Try one of these:"
     $0 -? | expand | sed -e 's:^:  :'
esac
