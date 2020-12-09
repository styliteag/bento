#!/bin/sh -eux

# Custom things i want in my template

. /etc/lsb-release

newhostname=$(echo "ubuntu-${DISTRIB_RELEASE}-template-sty"|tr "." "-")
echo "Setting Hostname to $newhostname"
hostnamectl set-hostname $newhostname

echo "Setting German Keyboard on console"
localectl set-keymap de nodeadkeys

echo "remove nfs-common rpcbind"
apt-get -y purge nfs-common rpcbind || true;

echo "remove vagrant dev-packages"
apt-get -y purge libssl-dev libreadline-dev zlib1g-dev linux-source dkms nfs-common linux-headers-$(uname -r) perl cifs-utils rsync 

echo "remove snapd"
apt-get -y purge snapd

echo "remove geoip-database"
apt-get -y purge geoip-database

echo "autoremoving packages and cleaning apt data"
apt-get -y autoremove;
apt-get -y clean;

apt-get -y autoremove