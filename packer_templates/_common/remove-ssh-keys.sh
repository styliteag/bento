#!/bin/sh -eux

# This must be the Last Step for Packer (It can not connect after)
echo "Remove Vagrant Keys"
rm /home/vagrant/.ssh/authorized_keys

echo "Remove sshd ssh_host_keys"
rm /etc/ssh/ssh_host_*

echo "Regenerate New ssh host keys on next boot"
cat > /etc/rc.local <<EOF
#!/bin/sh

test -f /etc/ssh/ssh_host_rsa_key || ssh-keygen -A

exit 0
EOF
chmod a+rx /etc/rc.local