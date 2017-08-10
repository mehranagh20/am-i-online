#!/bin/bash

AUTHOR="Mehran Aghabozorgi"

export DISPLAY=:1
export XAUTHORITY=/run/user/1000/gdm/Xauthority 

CONNTECTED=true
DNS_WORKING=true
NUM_TRIED_FOR_RESOLVING=0           # number of failed attempts for dns resolving.
IP=4.2.2.2                          # if attempting to ping to check connectivity.
URLS=("google.com" "github.com")    # list of urls we attempt to resolve for dns.
SWBND=10                            # seconds waiting before notifing disconnection, for being sure
NOABND=3                            # number of attemps for dns resolving before being sure dns has problem.

notify-send "Am I Online?"  "Watching Internet Connection Started"

while true; do
    if $CONNECTED; then
        if ! ping -q -c 1 -W 1 $IP > /dev/null 2>&1; then
            if (( $SECONDS > $SWBND )); then
                notify-send "Am I Online? Got disconnected" "I'll notify you as soon as you get back online :)"
                CONNECTED=false
                DNS_WORKING=false

            else
                continue
            fi

        else 
            SECONDS=0
            
            DNS_OK=false
            for URL in ${URLS[@]}; do
                if ping -q -c 1 -W 1 $URL > /dev/null 2>&1; then
                    DNS_OK=true
                    break
                fi
            done

            if ! $DNS_OK; then
                (( NUM_TRIED_FOR_RESOLVING += 1 ))

                if (( NUM_TRIED_FOR_RESOLVING >= $NOABND )) && $DNS_WORKING; then
                    notify-send "Am I Online? DNS is not working properly" "I'll notify you as soon as it gets ok :)"
                    DNS_WORKING=false
                fi

            else
                NUM_TRIED_FOR_RESOLVING=0

                if ! $DNS_WORKING; then
                     notify-send "Am I Online? DNS is now ok" "I'll notify you in case of problem :)"
                     DNS_WORKING=true
                fi
            fi

        fi
        
        sleep 5
    else
        :
    fi
done
