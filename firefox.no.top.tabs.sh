#!/usr/bin/env bash

cat << EOF
/*
  - To hide tabs in Firefox:
    - Place this file in the following location:
      dir=/Users/glennaws/Library/Application Support/Firefox/Profiles/XXXXXXXX.default/chrome
                                                                       ^^^^^^^^ (will be different)
    - mkdir -p $dir 
    - $0 >> $dir/userChrome.css
    - open config:about in Firefox
      - search for "toolkit.legacyUserProfileCustomizations.stylesheets"
        - set to 'true'
    - restart Firefox

  - To adjust colors of the tabs
    - Tree Style Tab preferences
      - Advanced:
        - Add into text box:
          :root{
            --tab-surface-regular: #1C1A1A;
            --tab-surface-active: #3E553E;
            --tab-surface-hover: #6A6A6A;
            --tab-surface-active-hover: #5F975C;
            --tab-text-regular: #B7B7B7;
            --tab-text-active: #FFFFFF;
            --tab-text-hover: #000000;
          }
*/

#TabsToolbar {
  visibility: collapse;
}
EOF

