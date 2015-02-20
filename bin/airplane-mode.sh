#!/bin/bash

state=${1:-Off}

osascript -e "
tell application \"System Preferences\"
    set the current pane to pane id \"com.apple.preferences.Bluetooth\"
    tell application \"System Events\"
        tell process \"System Preferences\"
            tell window \"Bluetooth\"
                tell button 3
                    if name is \"Turn Bluetooth $state\" then click
                end tell
            end tell
        end tell
    end tell
    quit
end tell
"

networksetup -setairportpower en0 $state

