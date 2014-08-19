#!/bin/bash
# NOTE: this script will not work correctly if the duplicated address is the one of this same computer on which this script is being run. But in our case it's not a problem because we regularly test other network services which are on this computer (e.g. asterisk).
IPS=""
for i in {1..254}; do
  IP=192.168.40.$i
  sudo arping -d -i eth0 -c 1 $IP &>/dev/null
  if [ $? -ne 0 ]; then
    IPS="$IPS $IP"
  fi
done
if [ -n "$IPS" ]; then
  for j in 192.168.40.190 192.168.40.152 192.168.40.159 192.168.40.175; do
    echo -e "$(date +'%F %R')\n\nDUPLICATE IP(S): $IPS" | smbclient -N -M debian -I $j > /dev/null
  done
fi
