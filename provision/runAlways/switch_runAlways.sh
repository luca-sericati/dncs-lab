#!/usr/bin/env bash
echo -e "\033[1;36mBring up NICs\033[0m"
ip link set enp0s8 up
ip link set enp0s9 up
ip link set enp0s10 up
