#!/bin/sh -eux

# Custom things i want in my template

echo "remove nfs-common rpcbind"
apt-get -y purge nfs-common rpcbind || true;

echo "remove vagrant dev-packages"
apt-get -y purge libssl-dev libreadline-dev zlib1g-dev linux-source dkms nfs-common linux-headers-$(uname -r) perl cifs-utils rsync 

echo "autoremoving packages and cleaning apt data"
apt-get -y autoremove;
apt-get -y clean;

apt-get -y autoremove