#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net and routing tables\033[0m"
ifconfig enp0s8 102.0.0.1 netmask 255.255.255.128 broadcast 102.0.0.127 up
ifconfig enp0s9 100.0.0.2 netmask 255.255.255.252 broadcast 100.0.0.3 up
ip route add 101.0.0.0/22 via 100.0.0.1 dev enp0s9
