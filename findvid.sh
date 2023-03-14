#!/usr/bin/env bash
. ~/.bashrc

echo "USE RB VERSION (in ~/usr/bin/findvid)"
exit 1

usage() {
  (
    if [ -n "$1" ]; then
      echo "x${@}"
    fi
    echo "usage: $(basename $0) [-d] -"
    echo "   or: $(basename $0) [-d] -n"
    echo "   or: $(basename $0) [-d] UID"
    echo "   or: $(basename $0) [-d] <SEARCH_STRING>..."
    echo "       -d  separate results by directory"
    echo "       -   clipboard will hold a string to look for"
    echo "       -n  clipboard will hold a uid-prefix string, and only the uid will be searched for"
  ) | cat 1>&2
  exit 1
}

cleann() {
  # examples that return '665572'
  #cleann '#665572#some.name.mp4'
  #cleann '#665572#'
  #cleann '#665572'
  #cleann '#####665572'
  #cleann '665572'
  #cleann '_5_#048585#abcd.txt'
  #echo >&2 '->'$1'<-'
  case "$1" in
    *#*#*) n=`echo "$1" | sed -e 's/#FAV#/#/' -e 's/#[0-9][0-9][0-9]bpm#/#/' -e 's/^[^#]*//' -e 's/[^#]*$//' -e 's/^#*//' -e 's/#*$//'`
           # echo >&2 n:$n:
           case "$n" in
             [0-9][0-9][0-9][0-9][0-9][0-9]) true ;;
             *) usage "ERROR: '$n' is not a 6 digit number";;
           esac
           ;;
    *)     usage "ERROR: '$1' is not in correct format";;
  esac
  #echo >&2  '->'$n'<-'
  echo "$n"
}

cd t:/Premiere.Pro.Work || o bitlocker || exit 1
\ls ./\#* > find 2>/dev/null
dir="t:/RECYCLABLE/v/"
cd $dir || o bitlocker || exit 1

find . -type f > find.txt

if [ "$1" = "-d" ]; then
  separated=true
  shift
fi

if [ "$1" = "" ]; then
  usage
fi

if [ "$1" = '-n' -o "$1" = '-' ]; then
  if [ "$1" = '-n' ]; then
    number_only='true'
  fi
  shift
  if [ $# != 0 ]; then
    usage "ERROR: '-' or '-n' take no additional arguments"
  fi
  set -- $(p)
  if [ $# != 1 ]; then
    usage "ERROR: clipboard contains more than one string!"
  fi
  if [[ ! "$1" =~ ^#?[0-9][0-9][0-9][0-9][0-9][0-9] ]]; then
    if [ "$number_only" = 'true' ]; then
      usage "ERROR: string does not start with a number!"
    fi
  fi
  if [ "$number_only" = 'true' ]; then
    set -- `cleann "$1"`
    if [ -z "$1" ]; then
      exit 1
    fi
  fi
fi

#thing="$( echo $num | sed -e 's:[^#]*#::' -e 's:#.*::' -e 's:^:#:' -e 's:$:#:' )"
#set -- $( echo $num | sed -e 's:[^#]*#::' -e 's:#.*::' -e 's:^:#:' -e 's:$:#:' ) ${@}

echo ========================== 1>&2
echo "searching for: \"$@\""  1>&2
echo ========================== 1>&2

args=''
for arg in "$@"; do
  if false ; then
    args="${args}(?=.*$arg)"
  else
    args="${args}|${arg}"
  fi
done
args="${args#|}"
#echo args:$args
for arg in $@ ; do
  if [ -n "$args2" ]; then
    args2="${args2}"'|[^a-zA-Z/]'"${arg}"'[^a-zA-Z/]'
  else
    args2='[^a-zA-Z/]'"${arg}"'[^a-zA-Z/]'
  fi
done
#args2='('"${args2}"'[^a-zA-Z/])'
#args2="${args2}"'[^a-zA-Z/]'
args="${args2}"

old_d=""

unalias grep 2>/dev/null
if [ "$separated" != true ]; then
  cat find.txt | sed -e 's|^\.|t:/RECYCLABLE/v|' > find.txt_tmp
  cat t:/Premiere.Pro.Work/find | sed -e 's|^\.|t:/Premiere.Pro.Work|' >> find.txt_tmp
  cat find.txt_tmp | egrep -v '(jpg$|txt$|xmp$)' > find.txt_tmp2 && mv find.txt_tmp2 find.txt_tmp
  for arg in "$@"; do
    cat find.txt_tmp | grep -iE "${arg}[^/]*" > ~/find.txt_tmp2_$arg
    cat find.txt_tmp | grep -iE "${arg}[^/]*" > find.txt_tmp2 && mv find.txt_tmp2 find.txt_tmp
  done

  echo grep --color=auto -iE '('"$args"')' 1>&2
#      grep --color=auto -iE ([^a-zA-Z/]white[^a-zA-Z/]|[^a-zA-Z/]skirt[^a-zA-Z/])
  sleep 10

  cat find.txt_tmp | sed -e 's|^\.|t:/RECYCLABLE/v|' | \grep --color=auto -iE '('"$args"')'
else
  cat find.txt t:/Premiere.Pro.Work/find | egrep -v '(jpg$|txt$)|xmp$' | sort | grep --color=auto -iP "$args" | 
  sed -e 's|^./|'$dir'|' |
  while read line; do
    f=${line##*/}
    d=${line%$f}
    if [ "$d" != "$old_d" ]; then
      echo '===================================================================='
      echo dd=\"$d\"
      old_d="$d"
    fi
    echo '  start "${dd}/'$f'"'
  done | egrep -i --color=auto "$1|$" | grep --color=auto -iP "$args"
fi
