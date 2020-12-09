#!/bin/sh -eux

# Custom things i want in my template

version=$(sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release)
newhostname="oraclelinux-${version}-template-sty"
# newhostname=$(hostnamectl status | grep "Operating System:" | cut -d":" -f2  | tr -d " " | tr "." "-")
echo "Setting Hostname to $newhostname"
hostnamectl set-hostname $newhostname

echo "Setting German Keyboard on console"
localectl set-keymap de nodeadkeys

echo "remove nfs-common rpcbind"
dnf -y remove nfs-utils rsync 