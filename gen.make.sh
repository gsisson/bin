#!/usr/bin/env bash

sleep=60

grab_em() {
  patterns=()
  nat=$1
  if [ "$1" = all ]; then
    nat="AFRICA AMERICA ASIA INDIA"
  fi
  shift
  age=$1
  if [ "$1" = all ]; then
    age="A T C"
  fi
  shift
  dir=$1
  shift
  while [ $# != 0 ]; do
    case $1 in
      ex)  ex=true;;
      t=*) patterns+=(${1#t=});;
      *)   echo "ERROR: unrecoginized option '$1'"; sleep $sleep ; exit
    esac
    shift
  done
  target="${PWD}"
  tmpd=${target}/tmp/
  rmdir ${tmpd} 2>/dev/null
  if [ -d "$tmpd" ]; then
    echo "ERROR: tmpdir already exists! '$tmpd'" ; sleep $sleep ; exit
  fi
  rm -f *lnk
  for n in $nat; do
    case $n in
      AMERICA) n=AMER_LAT;;
      AFRICA)  n=AFR;;
      ASIA)    n=${n}N;;
      INDIA)   n=${n}N;;
    esac
    for a in $age; do
      d="T:/RECYCLABLE/v/_QUICK_"
      d="${d}FUN/____/categories/${dir}/_${a}_${dir}_${n}/"
      if [ "$ex" = true ]; then
        d="${d}/_${a}_${dir}_${n}_ex/"
      fi
      if [ ! -d "$d" ]; then
        echo "ERROR: dir DNE: '$d'" ; sleep $sleep ; exit
      fi
      mkdir -p "$tmpd"
      cd "$d"
        echo $(basename $d)
        cp *.lnk "$tmpd" 2>/dev/null
      cd - > /dev/null
      cd "$tmpd" || sleep 600
      if [ ${#patterns[@]} = 0 ]; then
        mv * .. 2>/dev/null
      else
        mkdir tmpd
        for pat in ${patterns[*]}; do
          echo "  pat=$pat"
          eval mv "*${pat}*" tmpd 2>/dev/null
          rm -f *lnk
          mv tmpd/* . 2>/dev/null
        done          
        rmdir tmpd
        mv * .. 2>/dev/null
        rm -f *
      fi
      cd - > /dev/null
      rmdir "$tmpd" || sleep 600
    done
  done
}

grab_em "${@}"
