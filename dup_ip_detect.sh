#!/bin/bash
IPS=""
for i in {1..254}; do
  IP=192.168.40.$i
  sudo arping -d -i eth0 -c 1 $IP &>/dev/null
  if [ $? -ne 0 ]; then
    IPS="$IPS $IP"
  fi
done
if [ -n "$IPS" ]; then
  for j in komp usv-6 usv11 usv-15; do
    echo -e "$(date +'%F %R')\n\nDUPLICATE IP(S): $IPS" | smbclient -N -M $j > /dev/null
  done
fi
