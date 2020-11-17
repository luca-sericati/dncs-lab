export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

# Startup commands for switch go here
echo -e "\033[1;33mSet ovs for VLANs\033[0m"
ovs-vsctl add-br mainbridge
ovs-vsctl add-port mainbridge enp0s8
ovs-vsctl add-port mainbridge enp0s9 tag=9
ovs-vsctl add-port mainbridge enp0s10 tag=10
