#!/usr/bin/env zsh

# raspberry pi temperatures
# TODO detect os, hardware, use corresponding commands
echo -n "GPU "
vcgencmd measure_temp
cpu=$(</sys/class/thermal/thermal_zone0/temp)
echo "CPU temp=$((cpu/1000)) c"
