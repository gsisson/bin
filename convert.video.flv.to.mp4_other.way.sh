#!/usr/bin/env bash

http://stackoverflow.com/questions/5678695/ffmpeg-usage-to-encode-a-video-to-h264-codec-format

f="$1"
echo + ffmpeg -i "$f.flv" -vcodec mpeg4 -acodec aac "$f.mp4"
       ffmpeg -i "$f.flv" -vcodec mpeg4  "$f.mp4"

