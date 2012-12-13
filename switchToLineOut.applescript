tell application "System Preferences" to reveal anchor "output" of pane id "com.apple.preference.sound"
tell application "System Events" to tell (table 1 of scroll area 1 of tab group 1 of window "Sound" of application process "System Preferences")
    select row 2
end tell
tell application "System Preferences" to quit
