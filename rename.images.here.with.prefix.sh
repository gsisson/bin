#!/usr/bin/env bash

if [ $# = 1 -a -n "$1" ]; then
  prefix="$1"
else
  prefix=$(basename $PWD)
fi

# get rid of any trailing dot, since we add our own
case $prefix in
  *\.) echo "ends in dot"
       prefix="${prefix%?}"
       ;;
esac

for f in *; do
  case "$f" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9]\.*)
      echo "stopping... you might want to run 'rename.images.picpic.date.compress.sh' first!"
      exit 1
      ;;
  esac
done

echo "using '$prefix' as prefix"

for f in *; do
  if [[ "${f}" =~ ^${prefix} ]]; then
    echo "skipping $f (already has prefix)"
    continue
  fi
  if [ ! -f "$f" ]; then
    continue
  fi
  if [ ! -f "${prefix}.$f" ]; then
     echo + mv "$f" "${prefix}.$f"
            mv "$f" "${prefix}.$f"
  else
    echo "WARNING: there would be a collision in renameing:"
    echo "  $f"
    echo "    to"
    echo "  ${prefix}.$f"
  fi
done


