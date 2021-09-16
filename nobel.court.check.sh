#!/usr/bin/env bash

echo "+ curl https://www.nobelcourt.com/floorplans"
echo "  | grep -i 'availableCount:' | grep -v 'availableCount: 0'"
echo
curl https://www.nobelcourt.com/floorplans 2>/dev/null | grep -i 'availableCount:' | grep -v 'availableCount: 0'
echo
