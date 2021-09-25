#!/usr/bin/env bash

for site in https://www.nobelcourt.com/floorplans https://www.lajollablueliving.com/floorplans; do
  echo
  echo "+ curl $site"
  echo "  | grep -i 'availableCount:' | grep -v 'availableCount: 0'"
  echo
  curl $site 2>/dev/null | grep -Ei '(availableCount:| name:)' | grep -v 'availableCount: 0'
done

echo
