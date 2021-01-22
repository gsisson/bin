#!/usr/bin/env bash

move_it() {
  echo + mv "$1" "$2"
         mv "$1" "$2"
}

move_em() {
  test=false
  if [ "$1" = '--test' ]
  then
    test=true
    shift
  fi
  if [ "$#" = '0' ]
  then
    set -- *
  fi
  
  collide=false
  for f in "${@}"; do # 2020-01-25_19-52-50_001.png
    t=${f//-/}
    t=${t//_/}
    case $f in
      [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9].jpg |\
      [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9].png |\
      [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9]_[hv].jpg |\
      [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9]_[hv].png)
        if [ "$test" = true ]; then
          if [ -f "$t" ]; then
             collide=true
             echo "exists: $t" 1>&2
          fi
        else
          move_it "$f" "$t"
        fi
        ;;
    esac
  done
  if [ "$collide" = true ]; then
    echo "ERROR: colliding filenames... aborting!" 1>&2
    exit 1
  fi
}

move_em --test
move_em
