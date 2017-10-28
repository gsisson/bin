#!/usr/bin/env bash

echo 
echo "use ffmpeg with the following options:"
echo 
echo "ffmpeg -i INPUT.avi -ss HH:MM:SS.xxx -t HH:MM:SS.xxx -acodec copy -vcodec copy OUTPUT.avi"
echo "  where -ss is the start time"
echo "        -t  is the duration"
echo
echo "example: ffmpeg -i INPUT.avi -ss 1:20 -t 22:10.3 -acodec copy -vcodec copy OUTPUT.avi"
echo "  where the clip starts at 1 min 20 seconds,"
echo "  and ends 22 min, 10.3 secends later"
echo
