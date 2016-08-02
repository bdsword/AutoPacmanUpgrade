#!/bin/sh

upgradable_aps=("DSNS Lab AP" "DSNS Lab AP-5G" "Free Wifi")

now_ap=$(iwgetid | sed 's/wlp3s0\s\+ESSID:"\(.\+\)"/\1/g')

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

for ((i = 0; i < ${#upgradable_aps[@]}; i++))
do
    if [[ ${upgradable_aps[$i]} == $now_ap ]]; then
        pacman -Syu --noconfirm
        break
    fi
done
