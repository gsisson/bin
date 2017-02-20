#!/usr/bin/env bash

# this script (~/usr/bin/play.movie_00.05.25.sh) will play a single video
# file found in the same directory as this script, and at the time index
# indicated by the time encoded in the script's name.

# Note: to allow double click to shart this .sh file, run the following once
#   ~/usr/bin/assoc.sh.double.click.bat

cd "$(dirname $0)"

movie=$(\ls *.mkv *.avi 2>/dev/null)
echo movie:$movie

pos=$(basename $0)
pos=${pos%.sh}
pos=${pos##*_}

pos="${pos//./:}"

echo + play "$movie" "$pos"
       play "$movie" "$pos"
