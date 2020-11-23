#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net (including vlans) and routing table\033[0m"
ip link set enp0s8 up
modprobe 8021q
vconfig add enp0s8 9
ip addr add 10.101.0.1/24 dev enp0s8.9
vconfig add enp0s8 10
ip addr add 10.101.2.1/23 dev enp0s8.10
ip link set enp0s8.9 up
ip link set enp0s8.10 up

# ifconfig enp0s8 10.101.0.1 netmask 255.255.252.0 broadcast 10.101.3.255 up
# ifconfig enp0s9 10.100.0.1 netmask 255.255.255.252 broadcast 10.100.0.3 up
ip addr add 10.100.0.1/30 dev enp0s9
ip link set enp0s9 up
ip route add 10.102.0.0/25 via 10.100.0.2 dev enp0s9