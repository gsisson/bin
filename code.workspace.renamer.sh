#!/usr/bin/env bash

root=.
if [ ! -d .git ]; then
  root=`echo ${PWD/$(git rev-parse --show-toplevel || echo .)?/} | sed -e "s|[^/][^/]*|..|g"`
fi

if [ $# != 2 ]; then
  echo
  echo "ERROR: missing arguments"
  echo "usage: `basename $0` OLD_STORY_NUM NEW_STORY_NUM"
  echo
  echo "found these to work on:"
  c="--color=always"
  find $root | grep code-workspace | sed -e 's|^|  |' | grep $c '.*/'  | grep $c '.code-workspace'
  exit 1
fi
OLD_STORY_NUM="$1"
NEW_STORY_NUM="$2"
find $root | grep code-workspace | while read f; do
  src="$f"
  tgt="${f//${OLD_STORY_NUM}/${NEW_STORY_NUM}}"
  echo "mv   ${f}"
  echo "   ->${f//${OLD_STORY_NUM}/${NEW_STORY_NUM}}" | grep --color=always -iE "($|${NEW_STORY_NUM})"
  #echo mv $src $tgt
  eval mv $src $tgt
done

echo "and now we have these:"
find $root | grep code-workspace | sed -e 's|^|  |' | grep --color=always -iE "($|${NEW_STORY_NUM})"
