#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net (including vlans) and routing table\033[0m"
ip link set enp0s8 up
modprobe 8021q
vconfig add enp0s8 9
ip addr add 101.0.0.1/24 dev enp0s8.9
vconfig add enp0s8 10
ip addr add 101.0.2.1/23 dev enp0s8.10
ip link set enp0s8.9 up
ip link set enp0s8.10 up

# ifconfig enp0s8 101.0.0.1 netmask 255.255.252.0 broadcast 101.0.3.255 up
ifconfig enp0s9 100.0.0.1 netmask 255.255.255.252 broadcast 100.0.0.3 up
ip route add 102.0.0.0/25 via 100.0.0.2 dev enp0s9