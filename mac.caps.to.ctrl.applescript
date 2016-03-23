#!/usr/bin/osascript

tell application "System Preferences"
    activate
    set current pane to pane "com.apple.preference.keyboard"
end tell

tell application "System Events"
    get properties
    tell application process "System Preferences"
        click button "Modifier Keys..." of tab group 1 of window "Keyboard"
    end tell
end tell
