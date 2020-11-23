#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net and routing tables\033[0m"
# ifconfig enp0s8 10.102.0.1 netmask 255.255.255.128 broadcast 10.102.0.127 up
ip addr add 10.102.0.1/25 dev enp0s8
ip link set enp0s8 up
# ifconfig enp0s9 10.100.0.2 netmask 255.255.255.252 broadcast 10.100.0.3 up
ip addr add 10.100.0.2/30 dev enp0s9
ip link set enp0s9 up
ip route add 10.101.0.0/24 via 10.100.0.1 dev enp0s9
ip route add 10.101.2.0/23 via 10.100.0.1 dev enp0s9
