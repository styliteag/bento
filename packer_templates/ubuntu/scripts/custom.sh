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

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history

echo "==> Clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

# echo "Installing cloud-init"
# apt-get -y install cloud-init
# apt-get install -y -f cloud-init cloud-utils #cloud-initramfs-growroot

# Remove some packages to get a minimal install
#echo "==> Removing all linux kernels except the currrent one"
##dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v $(uname -r) | xargs apt-get -y purge
#apt-get -y purge `ls /boot/vmlinuz-* | sed -e '$d' | sed s/.*vmlinuz/linux-image/`
#apt-get -y purge $(dpkg --list |egrep 'linux-image-[0-9]' |awk '{print $3,$2}' |sort -nr |tail -n +2 |grep -v $(uname -r) |awk '{ print $2}')
#apt-get -y purge $(dpkg --list |grep '^rc' |awk '{print $2}')
echo "==> Removing linux source"
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge
echo "==> Removing documentation"
dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge
#echo "==> Removing development packages"
#dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge
#echo "==> Removing development tools"
#dpkg --list | grep -i compiler | awk '{ print $2 }' | xargs apt-get -y purge
#apt-get -y purge cpp gcc g++
#apt-get -y purge build-essential git
#echo "==> Removing default system Ruby"
#apt-get -y purge ruby ri doc
#echo "==> Removing default system Python"
#apt-get -y purge python-dbus libnl1 python-smartpm python-twisted-core libiw30 python-twisted-bin libdbus-glib-1-2 python-pexpect python-pycurl python-serial python-gobject python-pam python-openssl libffi5
#echo "==> Removing other oddities"
#apt-get -y purge popularity-contest installation-report landscape-common wireless-tools wpasupplicant
#apt-get -y purge nano


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

## Remove 5s grub timeout to speed up booting
## If this is enabled then Disable Predictable Network Interface names and use eth0 will not be used
#sed -i -e 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' \
#    -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="nosplash"/' \
#    -e 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0,115200"/' \
#    -e 's/^#?GRUB_TERMINAL=.*/GRUB_TERMINAL="console serial"/' \
#    /etc/default/grub
#update-grub