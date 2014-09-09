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
array=( 192.168.40.190 debian 192.168.40.152 usv-6 192.168.40.159 usv11 192.168.40.175 usv-15 );
if [ -n "$IPS" ]; then
  for j in {0..3}; do
    echo -e "$(date +'%F %R')\n\nDUPLICATE IP(S): $IPS" | smbclient -N -M ${array[$j*2+1]} -I ${array[$j*2]} > /dev/null
  done
fi
