#!/bin/bash

AUTHOR="Mehran Aghabozorgi"

CONNTECTED=true
DNS_WORKING=true
NUM_TRIED_FOR_RESOLVING=0           # number of failed attempts for dns resolving.
IP=4.2.2.2                          # if attempting to ping to check connectivity.
URLS=("google.com" "github.com")    # list of urls we attempt to resolve for dns.
SWBND=5                            # seconds waiting before notifing disconnection, for being sure
NOABND=3                            # number of attemps for dns resolving before being sure dns has problem.
NSSACC=1                            # number of seconds to sleep after each check of getting connection back.
NSSADC=2                            # number of seconds to sleep after each check of getting disconnected.

notify-send -i face-glasses "Am I Online?"  "Watching Internet Connection Started"

while true; do
    if $CONNECTED; then
        if ! ping -q -c 1 -W 1 $IP > /dev/null 2>&1; then
            if (( $SECONDS > $SWBND )); then
                notify-send -i face-sad "Am I Online? Got disconnected" "I'll notify you as soon as you get back online :)"
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
                    notify-send -i face-worried "Am I Online? DNS is not working properly" "I'll notify you as soon as it gets ok :)"
                    DNS_WORKING=false
                fi

            else
                NUM_TRIED_FOR_RESOLVING=0

                if ! $DNS_WORKING; then
                     notify-send -i face-smirk "Am I Online? DNS is now ok" "I'll notify you in case of problem :)"
                     DNS_WORKING=true
                fi
            fi

        fi
        
        sleep $NSSADC

    else

        if ping -q -c 1 -W 1 $IP > /dev/null 2>&1; then
            CONNECTED=true
            SECONDS=0
            
            DNS_OK=false
            for URL in ${URLS[@]}; do
                if ping -q -c 1 -W 1 $URL > /dev/null 2>&1; then
                    DNS_OK=true
                    break
                fi
            done

            if $DNS_OK; then
                DNS_WORKING=true
                notify-send -i face-cool "Am I Online? You got back online" "DNS seems to be ok too. i'll notify you in case of problem :) "

            else
                DNS_WORKING=false
                notify-send -i face-smile "Am I Online? You got back online" "DNS seems to have some problems, i'll notify you in case of problem :)"

            fi

        fi

        sleep $NSSACC

    fi
done
