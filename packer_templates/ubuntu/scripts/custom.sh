#!/bin/sh -eux

# Custom things i want in my template

. /etc/lsb-release

ubuntu_version="`lsb_release -r | awk '{print $2}'`";
major_version="`echo $ubuntu_version | awk -F. '{print $1}'`";

newhostname=$(echo "ubuntu-${DISTRIB_RELEASE}-template-sty"|tr "." "-")
echo "Setting Hostname to $newhostname"
hostnamectl set-hostname $newhostname

echo "Setting German Keyboard on console"
localectl set-keymap de nodeadkeys


if [ "$major_version" -ge "20" ]; then
  echo "Setting LANG C.UTF-8"
  localectl set-locale C.UTF-8
fi

echo "Setting Timezone Europe/Berlin"
timedatectl set-timezone Europe/Berlin

# echo "Installing cloud-init"
# apt-get -y install cloud-init
# apt-get install -y -f cloud-init cloud-utils #cloud-initramfs-growroot

echo "remove nfs-common rpcbind"
apt-get -y purge nfs-common rpcbind || true;

echo "remove vagrant dev-packages"
apt-get -y purge libssl-dev libreadline-dev zlib1g-dev linux-source dkms nfs-common linux-headers-$(uname -r) perl cifs-utils rsync 

echo "remove snapd"
apt-get -y purge snapd

echo "remove geoip-database"
apt-get -y purge geoip-database

echo "autoremoving packages and cleaning apt data"
apt-get -y autoremove
apt-get -y clean