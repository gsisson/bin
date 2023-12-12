#!/usr/bin/env bash

echo 1>&2 "+ waiting for input scraped from 'show source' of roster web page..."
expand | grep @ | grep -v '@media only screen' | sed -e 's|.*mailto:||' -e 's:" .*::'| sort -u 
