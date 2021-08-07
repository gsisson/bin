#!/usr/bin/env bash

# http://stackoverflow.com/questions/5678695/ffmpeg-usage-to-encode-a-video-to-h264-codec-format

opts="-hide_banner -loglevel error"

f="$1"
echo + ffmpeg $opts -i "$f.flv" -vcodec mpeg4 -acodec aac "$f.mp4"
       ffmpeg $opts -i "$f.flv" -vcodec mpeg4  "$f.mp4"

