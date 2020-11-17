#!/usr/bin/env bash
echo -e "\033[1;33mSetting ip forwarding\033[0m"
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl --system   #this is to reload config files.
#sysctl net.ipv4.ip_forward #check if it is enabled
