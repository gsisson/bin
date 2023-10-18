#!/usr/bin/env bash

cat << EOF
/*
  - To hide tabs in Firefox:
    - Place this file in the following location:
      dir=/Users/glennaws/Library/Application Support/Firefox/Profiles/XXXXXXXX.default/chrome
                                                                       ^^^^^^^^ (will be different)
      mkdir -p $dir 
      $0 >> $dir/userChrome.css
    - open config:about in Firefox
      - search for "toolkit.legacyUserProfileCustomizations.stylesheets"
        - set to 'true'
    - restart Firefox
*/

#TabsToolbar {
  visibility: collapse;
}
EOF

