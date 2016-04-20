#!/usr/bin/env bash

echo "run one of these:"
echo "  bundle install --path vendor/bundle   # keep gems in the project"
echo "  bundle install --system               # use (shared) system gems"
if [ -f .bundle/config ]; then
  echo
  echo "  current contents of .bundle/config:"
  cat .bundle/config | sed -e 's:^:    | :'
  echo
fi
