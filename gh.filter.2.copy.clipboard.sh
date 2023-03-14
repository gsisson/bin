#!/usr/bin/env bash

# + "athena:DeleteDataCatalog",

echo >&2 "reading from stdin..."

sed -e 's:AccessDenied.*:AccessDenied:' |
  grep -v '+ pattern' |
  grep -E  'Ran Apply for |^[0-9]+|(Creation complete|Apply complete|no such file or directory|not compatible with regional workflow|will be created|will be destroyed|will be updated|deleted|replaced|removed|_____Region|______Account Name|Infrastructure is up-to-date|AccessDenied|devopsbot)' |
  grep -iE -- '(-gdna-ai-|$)' |
  sed -e 's:^__*::' \
      -e 's:^:  - :' \
      -e 's|  -   # |   - |' \
      -e 's|  - Account Name|- Account Name|' \
      -e 's:__*$::' \
  | grep -v 'Sucessfully assumed into role, devopsbot'

exit

      -e 's:^  # :- :' \
      -e 's:^Account Name:- Account Name:' \
      -e 's:__*$::' \
      -e 's:^Region:### Region:'
