# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 184 and 303 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 104 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

## Network topology
![Network topology](doc/networkTopology.png "Network topology diagram")

First of all in oreder to accomplish the task it is necessary to set up the netmasks and the ip addresses of the subnets.

In the subnet host-a it is necessary to scale up 184 usable addresses so I decided to use a netmask of `255.255.255.0` that allows 255 addresses. Considering that one of them is used for the broadcast and another for the gateway (router-1) we obtain 253 usable addresses. I decided to give to this subnet a network address of `101.0.0.0/24`.

Similarly for the host-b subnet I used an address of `101.0.2.0/23` because, in this case with 303 hosts, we need at least 9 bits for the host address. In fatc with 9 bits we obtain 2^9 - 2 = 510 usable addresses.

Finally for the host-c we have only 104 hosts so 7 bits of host address are enaugh. To be sure, 2^7 - 2 = 125 usable addresses. The network address choosen is `102.0.0.0/25`.

We need also another subnet which connects the two routers. Only two hosts to address but including the broadcast address we need at least 2 bits (2^2 - 1 = 3). I opted for a `100.0.0.0/30` network address.

host-a and host-b need to be in two separate netwok but due to the fact that they are connected to the same switch and router-1 has only one NIC connected to the switch I decided to use VLANs. In particular we have VLAN tag 9 used to manage the network `101.0.0.0` and VLAN tag 10 for network `101.0.2.0`.

## host-a

For host-a I added a file to the provision that runs at every start up of the machine with this three lines:

```bash
ifconfig enp0s8 101.0.0.2 netmask 255.255.255.0 broadcast 101.0.0.255 up
ip route add 101.0.2.0/23 via 101.0.0.1 dev enp0s8
ip route add 102.0.0.0/25 via 101.0.0.1 dev enp0s8
```

The first one configure the interface `enp0s8` with the ip `101.0.0.2/25` and with the broadcast address set to `101.0.0.255`.

The second one configure the route for reaching host-b. In particular it says: in order to reach the netowrk `101.0.2.0/23` it is necessary to contact the gateway with ip `101.0.0.1` using the interface `enp0s8`.

Similarly the third line allow host-a to connect to host-c.

## host-b

The same configuration as host-a is used for host-b changing the ip addresses and the netmask according with the previus choices.

```bash
ifconfig enp0s8 101.0.2.2 netmask 255.255.254.0 broadcast 101.0.3.255 up
ip route add 101.0.0.0/24 via 101.0.2.1 dev enp0s8
ip route add 102.0.0.0/25 via 101.0.2.1 dev enp0s8
```

## host-c

host-c has also a script that runs only when the machine is installed. This script is used to install docker and to pull the `dustnic82/nginx-test` image.

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

docker pull dustnic82/nginx-test
```
We also have a script that runs at every start up which configures the network and runs the docker image.

```bash
ifconfig enp0s8 102.0.0.2 netmask 255.255.255.128 broadcast 102.0.0.127 up
ip route add 101.0.0.0/24 via 102.0.0.1 dev enp0s8
ip route add 101.0.2.0/23 via 102.0.0.1 dev enp0s8

docker run -d -p 80:80 dustnic82/nginx-test
```

In this, the first three lines acts as for host-a and host-b. The last one runs the docker image as daemon connecting port 80 to the port 80 of host-c.

In order to run docker on host-c it was necessary to increase the vb-memory to 512 in the Vagrantfile.

## switch

## router-1

## router-2