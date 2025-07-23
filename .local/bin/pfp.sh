#!/bin/bash

gdbus call --system \
  --dest org.freedesktop.Accounts \
  --object-path /org/freedesktop/Accounts/User$(id -u) \
  --method org.freedesktop.DBus.Properties.Get \
  org.freedesktop.Accounts.User IconFile |
  cut -d\' -f2
