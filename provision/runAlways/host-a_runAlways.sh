#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net and default gateway\033[0m"
ifconfig enp0s8 10.101.0.2 netmask 255.255.255.0 broadcast 10.101.0.255 up
ip route add 10.101.2.0/23 via 10.101.0.1 dev enp0s8
ip route add 10.102.0.0/25 via 10.101.0.1 dev enp0s8
