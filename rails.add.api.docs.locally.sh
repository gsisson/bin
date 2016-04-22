#!/usr/bin/env bash

echo 'To get local rails docs, for a project:'
echo '  echo "doc/api/" >> .gitignore'
echo '  rake doc:rails # this takes 1 or 2 minutes, EVERY time you run it (no caching)'
echo '  open doc/api/index.html'
