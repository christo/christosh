#!/usr/bin/env bash

# $1 = egrep options
# $2 = pattern
# $3 = message
function grepdev() {
    flags=$1
    pattern=$2
    mesg=$3
    output=$(ls -lt /dev | grep '^c' | egrep "$flags" "$pattern" | head -n 12)
    if [[ ! -z "$output" ]]; then 
        echo $mesg
        echo -n "$output"
        echo
    fi
}

grepdev -i usb "smart guess:"
grepdev -vi '(disk|Bluetooth|BIGJAMBOX|Bose|autofs|console|null|rdisk|vbox)' "filtered:"
grepdev -i . raw:

