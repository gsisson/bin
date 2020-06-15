#!/usr/bin/env bash

# https://apple.stackexchange.com/questions/366542/install-spotify-cant-be-opened-because-apple-cannot-check-it-for-malicious-so

if [[ $# == 0 ]]; then
  echo "usage: $(basename $0) UNSIGNED_APPLICATION"
  echo "   ex: $(basename $0) /Applications/LiverFood/9.5.1.app"
  exit 1
fi

set -x
xattr -d com.apple.quarantine "${@}"
