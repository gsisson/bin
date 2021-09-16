#!/usr/bin/env bash

mkdir -p x; for f in *.avi
do
  convert.avi.to.mp4.sh -d x $f
done
