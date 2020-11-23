#!/usr/bin/env bash
echo -e "\033[1;36mConfiguring net and default gateway\033[0m"
# ifconfig enp0s8 10.102.0.2 netmask 255.255.255.128 broadcast 10.102.0.127 up
ip addr add 10.102.0.2/25 dev enp0s8
ip link set enp0s8 up
ip route add 10.101.0.0/24 via 10.102.0.1 dev enp0s8
ip route add 10.101.2.0/23 via 10.102.0.1 dev enp0s8

echo -e "\033[1;36mRun docker image\033[0m"
docker run -d -p 80:80 dustnic82/nginx-test
