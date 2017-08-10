#!/bin/bash

export DISPLAY=:1
export XAUTHORITY=/run/user/1000/gdm/Xauthority 
notify-send 'working'

while true; do
    if ping -q -c 1 -W 1 4.2.2.2 > /dev/null 2>&1; then
        if (( $SECONDS  >= 10 )); then
            notify-send "back online :) after $SECONDS seconds"
        fi
        SECONDS=0
    elif (( $SECONDS >= 5 )); then
        notify-send "got disconnected"
    fi

done
