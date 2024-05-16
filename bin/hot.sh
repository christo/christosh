#!/usr/bin/env zsh

# raspberry pi temperatures
# TODO detect os, hardware, use corresponding commands
echo -n "GPU "
# trim everything after last temp digit 
vcgencmd measure_temp | perl -pe 's/(.*\d).*/\1/'
cpu=$(</sys/class/thermal/thermal_zone0/temp) | perl -pe 's/(.*\d).*/\1/'
echo "CPU temp=$((cpu/1000)) c"
