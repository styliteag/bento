#!/bin/sh -eux

# Custom things i want in my template

# Install ssh-keys to root user
echo "Installing ssh-keys to User root"
mkdir -p /root/.ssh
chmod 700 /root/.ssh

touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

curl ${PACKER_HTTP_ADDR}/authorized_keys >> /root/.ssh/authorized_keys


echo "Disable empty password login"
sed -i 's/#\?\(PermitEmptyPasswords\s*\).*$/\1 no/' /etc/ssh/sshd_config
echo "Disable password login"
sed -i 's/#\?\(PasswordAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config
echo "Enable PAM"
sed -e 's/#\?\(UsePAM\s*\).*$/\1 yes/' -i /etc/ssh/sshd_config