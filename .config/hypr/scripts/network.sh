#!/bin/sh

status="$(nmcli general status | awk 'NR==2 {print $1}')"

if [ "$status" = "disconnected" ]; then
  echo "Disconnected 󰤮⠀"
  exit
fi

if [ "$status" = "connecting" ]; then
  echo "Connecting 󱍸⠀"
  exit
fi

if [ "$status" = "connected" ]; then
  connection_type="$(nmcli con show --active | awk 'NR==2 {print $(NF-1)}')"
  if [ "$connection_type" = "ethernet" ]; then
    echo
    exit
  fi

  ssid="$(nmcli -g name connection show --active | awk 'NR==1')"
  strength="$(awk 'NR==3 {print $3}' /proc/net/wireless | sed 's/\.//g')"
  if [ "$strength" = "" ]; then
    echo "$ssid"
    exit
  fi

  if [ "$strength" -eq "0" ]; then
    echo "$ssid 󰤯"
  elif [ "$strength" -ge "0" ] && [ "$strength" -le "25" ]; then
    echo "$ssid 󰤟"
  elif [ "$strength" -ge "25" ] && [ "$strength" -le "50" ]; then
    echo "$ssid 󰤢"
  elif [ "$strength" -ge "50" ] && [ "$strength" -le "75" ]; then
    echo "$ssid 󰤥"
  elif [ "$strength" -ge "75" ] && [ "$strength" -le "100" ]; then
    echo "$ssid 󰤨"
  fi
fi
