#!/usr/bin/env bash

echo '' | pbcopy
n=0

rm -f tmpf BIG

echo >&2 "creating file 'BIG'..."
echo >&2 "awaiting changes to content on clipboard..."

while : ; do
         pbpaste > tmpf
         sum=`sum tmpf`
         if [ "${oldsum}" != "${sum}" ]; then
           cat tmpf >> BIG
           echo adding
           oldsum="${sum}"
           echo oldsum:${sum}
         fi
         sleep 1
       done

rm tmpf
