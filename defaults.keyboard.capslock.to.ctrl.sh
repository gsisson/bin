#!/usr/bin/env bash
echo 'remapping caps lock to be control...'

kbdVendorID=1452
kbdVendorID=$( ioreg -n IOHIDKeyboard -r | grep \"VendorID\"  | sed -e 's:.* ::')
kbdProductID=610
kbdProductID=$(ioreg -n IOHIDKeyboard -r | grep \"ProductID\" | sed -e 's:.* ::')

# remap 
set -x

defaults -currentHost write \
   -g com.apple.keyboard.modifiermapping.${kbdVendorID}-${kbdProductID}-0 \
   -array '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer><key>HIDKeyboardModifierMappingDst</key><integer>2</integer></dict>'

set +x 2>/dev/null
echo
echo 'NOTE: you must logoff/login for this to take effect!'

exit

This is what will be written:

    "com.apple.keyboard.modifiermapping.1452-610-0" =     (
        {
            HIDKeyboardModifierMappingDst = 2;
            HIDKeyboardModifierMappingSrc = 0;
        }
    );

# keycodes:
#   -1 none
#   0 caps lock      -------+ 0 maps to 2, so
#   1 left shift            | 'caps lock' becomes
#   2 left control  <-------+ 'left control'
#   3 left option
#   4 left command
#   5 keypad 0
#   6 help
#   9 right shift
#   10 right control
#   11 right option
#   12 right command
