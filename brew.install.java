#!/usr/bin/env bash

set -x
brew update || { echo -e "\nERROR: brew update failed!\n"; exit 1 }


echo "handle some problems with old brew installations of cask..."
brew tap caskroom/cask > /dev/null 2>&1
brew install brew-cask > /dev/null 2>&1
brew unlink brew-cask  > /dev/null 2>&1
brew install brew-cask > /dev/null 2>&1

brew cask install java
