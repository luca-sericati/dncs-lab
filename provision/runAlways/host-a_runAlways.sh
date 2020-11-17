#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net and default gateway\033[0m"
ifconfig enp0s8 101.0.0.2 netmask 255.255.255.0 broadcast 101.0.0.255 up
ip route add 101.0.2.0/23 via 101.0.0.1 dev enp0s8
ip route add 102.0.0.0/25 via 101.0.0.1 dev enp0s8
