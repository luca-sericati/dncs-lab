#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net and default gateway\033[0m"
# ifconfig enp0s8 10.101.2.2 netmask 255.255.254.0 broadcast 10.101.3.255 up
ip addr add 10.101.2.2/23 dev enp0s8
ip link set enp0s8 up
ip route add 10.101.0.0/24 via 10.101.2.1 dev enp0s8
ip route add 10.102.0.0/25 via 10.101.2.1 dev enp0s8
