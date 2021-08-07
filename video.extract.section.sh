#!/usr/bin/env bash

echo ''
echo ' use ffmpeg with the following options:'
echo ''
echo ' opt1="-hide_banner -loglevel error"'
echo ' opt2="-avoid_negative_ts make_zero"'
echo ' ffmpeg -ss 00:05:12.912 -t 00:00:21.991 -i IN.mk4 -c copy OUT.mk4 $opt1 $opt2'
echo '            ^start time^    ^^duration^^'
echo ' or'
echo ' ffmpeg -ss 00:05:12.912 -to 00:15:12.991 -i IN.mk4 -c copy OUT.mk4 $opt1 $opt2'
echo '            ^start time^     ^^end time^^'
echo
echo ' (for keyframe alighment, place -ss BEFORE -i and use -avoid_negative_ts make_zero)'
echo ' (for keyframe alignment when encoding try -noaccurate_seek)'
echo ' (fyi: -hide_banner -loglevel error)'
