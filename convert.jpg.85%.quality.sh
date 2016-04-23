#!/usr/bin/env bash

echo  + mogrify -interlace Plane -quality '85%'
        mogrify -interlace Plane -quality '85%' "${@}"
