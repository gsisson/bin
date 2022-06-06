#!/usr/bin/env bash
echo
echo 'opts="-c:v libx264 -pix_fmt yuv420p -c:a aac -strict experimental -movflags +faststart"'
echo 'ffmpeg -i IN.m4v $opts OUT.mp4'
echo
