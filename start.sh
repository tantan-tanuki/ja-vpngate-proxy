#!/bin/env bash

VPNGATE_URL=http://www.vpngate.net/api/iphone/

function global_ip {
  curl -s inet-ip.info
}

# vpn connect func
function connect {
  while :; do 
    echo start
    while read line; do 
      line=$(echo $line | cut -d ',' -f 15)
      line=$(echo $line | tr -d '\r')
      openvpn <(echo "$line" | base64 -d) ;
    done < <(curl -s $VPNGATE_URL | grep ,Japan,JP, | grep -v public-vpn- | sort -R )
    echo end
  done
}

BEFORE_IP="$(curl -s inet-ip.info)"

# start proxy
privoxy <(grep -v listen-address /etc/privoxy/config ; echo listen-address  0.0.0.0:8118) &

# connect vpn
connect &

# vpn check
while :; do
  sleep 5
  AFTER_IP=$(global_ip)
  echo $BEFORE_IP "==" $AFTER_IP
  if [ $? -ne 0 ]; then
    pkill openvpn
  elif [ "$BEFORE_IP" = "$AFTER_IP" ]; then
    pkill openvpn
  else 
    sleep 55
  fi
done