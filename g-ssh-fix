#!/usr/bin/env bash

set -e

#if grep --color=always github.com-g .git/config
#if grep --color=always github.com-g `git rev-parse --show-toplevel`/.git/config
#then
#  echo "ERROR: found 'github.com-g' inside of .git/config"
#  exit 1
#fi

svc="github.com-g"
svc="github.com"

#org="${org}Outpost"
 org="${org}Service"
#org="${org}LandRove"
 org="${org}Transition"

case $1 in
 doit) for f in $(grep -l "github.com/${org}" `find . -type f | grep tf$ | grep -v .terraform/` /dev/null); do
         if grep -q "git::ssh://git@${svc}/${org}" $f; then
           echo "already done: $f"
         else
           echo "fixing:       $f"
           sed -i '' -e 's|"github.com/'${org}'|"git::ssh://git@'${svc}'/'${org}'|' $f
         fi
       done
       find . -type d | grep -q --color=always /.terraform$
       if [ $? = 0 ]; then
         #echo "found these .terraform/ directories (you may need to delete):"
         find . -type d | grep --color=always /.terraform$ | sed -e 's:$: # maybe delete?:'
       fi
       ;;
 undo) for f in $(grep -l "git::ssh://git@${svc}/${org}" `find . -type f | grep tf$ | grep -v .terraform/` /dev/null); do
         echo "restoring:    $f"
         sed -i '' -e 's|"git::ssh://git@'${svc}'/'${org}'|"github.com/'${org}'|' $f
       done
       ;;
 *)    echo "usage: $(basename $0) doit|undo"; exit 1 ;;
esac

