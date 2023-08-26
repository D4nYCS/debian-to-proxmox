#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

apt install proxmox-ve postfix open-iscsi

apt remove linux-image-amd64 'linux-image-6.1*'

update-grub

apt remove os-prober

ip a | grep enp | awk '{ print $NF }'

echo "auto lo" > /etc/network/interfaces
echo "iface lo inet loopbacke" >> /etc/network/interfaces

interface1='ip a | grep enp | awk '{ print $NF }''

echo "iface $interface1 inet manual" >> /etc/network/interfaces

echo "auto vmbr0" >> /etc/network/interfaces
echo "iface vmbr0 inet static" >> /etc/network/interfaces
echo "address 192.168.178.21/24" >> /etc/network/interfaces
echo "auto vmbr0" >> /etc/network/interfaces
echo "gateway 192.168.178.1" >> /etc/network/interfaces
echo "bridge-ports $interface1" >> /etc/network/interfaces
echo "bridge-stp off" >> /etc/network/interfaces
echo "bridge-fd 0" >> /etc/network/interfaces

echo "iface enp2s0 inet manual" >> /etc/network/interfaces
echo "bridge-stp off" >> /etc/network/interfaces

rm -rf $builddir