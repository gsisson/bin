#!/usr/bin/env bash

echo 'turning tap to click on...'
# for login screen
echo + defaults -currentHost write -globalDomain com.apple.mouse.tapBehavior -int 1
       defaults -currentHost write -globalDomain com.apple.mouse.tapBehavior -int 1
# for current user
echo + defaults              write -globalDomain com.apple.mouse.tapBehavior -int 1
       defaults              write -globalDomain com.apple.mouse.tapBehavior -int 1
# bluetooth trackpad
echo + defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
       defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
echo
echo 'NOTE: you must logoff/login for this to take effect!'
