#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
WHITE='\033[1;37m'

if (( $EUID != 0 )); then
    echo -e $RED Run the script as root with sudo !
    exit
fi

if [[ "$1" == "--install" ]]; then
    mkdir -p ~/bin
    cp ./amionline.sh ~/bin

    echo "[Unit]
Description="Am I Online notifies you of changes in your internet connectivity and DNS resolution."
After=network.target

[Service]
ExecStart=$HOME/bin/amionline.sh
Environment="DISPLAY=$DISPLAY"
Environment="XAUTHORITY=$XAUTHORITY"

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/amionline.service

    sudo systemctl daemon-reload > /dev/null 2>&1 && echo -e $WHITE "Am I Online loaded as systemd service."
    sudo systemctl enable amionline.service > /dev/null 2>&1 echo -e $WHITE "Am I Online is enabled to start at boot."

    echo -e $GREEN "Am I Online is installed Successfully."

    sudo systemctl start amionline.service && echo -e "$GREEN Am I Online Started Successfully :)" 

elif [[ "$1" == "--remove" ]]; then
    rm ~/bin/amionline.sh > /dev/null 2>&1
    systemctl stop amionline.service > /dev/null 2>&1
    systemctl disable amionline.service > /dev/null 2>&1 && echo -e $WHITE "Stopped and Disabled Service."
    rm /etc/systemd/system/amionline.service > /dev/null 2>&1 && echo -e $WHITE "Removed Service."
    echo -e $RED "Am I Online is removed Successfully :(
    please let me know the reason.
    github.com/mehranagh20/am-i-online"

else
    echo -e $WHITE "Usage:
    sudo ./install [--install --remove]"
    
fi
