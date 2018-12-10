#!/usr/bin/env bash

echo ffmpeg -i INPUT -vf scale=WIDTHxHEIGHT,setsar=1:1 OUTPUT
