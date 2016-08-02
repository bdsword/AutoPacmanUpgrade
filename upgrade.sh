#!/bin/sh

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

should_upgrade=0

if [[ $(cat /sys/class/net/enp4s0f2/carrier) == 1 ]]; then
    wget -q --tries=10 --timeout=20 --spider http://google.com
    if [[ $? -eq 0 ]]; then
        should_upgrade=1
    fi
else
    upgradable_aps=("DSNS Lab AP" "DSNS Lab AP-5G" "FREE WIFI")

    now_ap=$(iwgetid | sed 's/wlp3s0\s\+ESSID:"\(.\+\)"/\1/g')

    for ((i = 0; i < ${#upgradable_aps[@]}; i++))
    do
        if [[ ${upgradable_aps[$i]} == $now_ap ]]; then
            should_upgrade=1
            break
        fi
    done
fi

if [[ $should_upgrade == 1 ]]; then
    pacman -Syu --noconfirm
fi
