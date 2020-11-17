#!/usr/bin/env bash
echo -e "\033[1;33mInstalling Docker and dustnic82/nginx-test\033[0m"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

docker pull dustnic82/nginx-test

# echo -e "\033[1;33mConfiguring the network\033[0m"
# mv /home/vagrant/99_DNCSnetwork.yaml /etc/netplan/99_DNCSnetwork.yaml
# sudo netplan apply
