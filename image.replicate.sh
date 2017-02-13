#!/usr/bin/env bash

if [ ! -d rand ]; then
  echo "directory rand/ DNE!"
  exit 1
fi

for f in *
do
  if [ -f "$f" ]; then
    let r="$RANDOM + 10000"
    echo + cp $f rand/$r.$f
           cp $f rand/$r.$f
  fi
done
