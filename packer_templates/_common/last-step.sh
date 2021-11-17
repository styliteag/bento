#!/bin/sh -eux

# This must be the Last Step for Packer (It can not connect after)
echo "Remove Vagrant Keys"
rm /home/vagrant/.ssh/authorized_keys

# Set password for root user
echo "Set password for root user"
echo "root:password" | chpasswd

# Disable vagrant user
echo "Disable vagrant user"
usermod -L vagrant

echo "Remove sshd ssh_host_keys"
rm /etc/ssh/ssh_host_*

echo "On Next Boot:"
echo " Regenerate New ssh host keys on next boot"
echo " Resize root disk"

cat > /etc/rc.local <<'EOF'
#!/bin/sh

test -f /etc/ssh/ssh_host_rsa_key || ssh-keygen -A

if [] -f /.root_resized ] ; then
    echo "Root partition already resized."
else
    # Resize root partition
    rootdev=$(df / | tail -1 | cut -d" " -f1)
    rootdisk=${rootdev}
    while [ "${rootdisk%[0-9]}" != "${rootdisk}" ]; do
          rootdisk=${rootdisk%[0-9]};
    done
    partnum=${rootdev#${rootdisk}}
    
    if [ -z "$partnum" ]; then
          # Maybe it is lvm
          lvdev=$(pvs --noheading | awk '{print $1}')
          lvdisk=${lvdev}
          while [ "${lvdisk%[0-9]}" != "${lvdisk}" ]; do
            lvdisk=${lvdisk%[0-9]};
          done
          lvpartnum=${lvdev#${lvdisk}}
          growpart /dev/sda 2 || true
          growpart ${lvdisk} ${lvpartnum}
          pvresize ${lvdev}
          lvextend -l +100%FREE ${rootdisk}
          resize2fs ${rootdisk}
    else
          # Its /dev/sdaX
          growpart $rootdisk 2 || true
          growpart $rootdisk $partnum
          resize2fs $rootdev
    fi
    touch /.root_resized
fi

exit 0
EOF
chmod a+rx /etc/rc.local