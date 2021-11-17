#!/bin/sh -eux

# Custom things i want in my template

stylite='
This system is built by Packer at Stylite AG
'

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-bento'
    cat >> "$MOTD_CONFIG" <<EOF2
#!/bin/sh
cat <<'EOF'
$stylite
EOF
EOF2
    chmod 0755 "$MOTD_CONFIG"
else
    echo "$stylite" >> /etc/motd
fi

# Install ssh-keys to root user
echo "Installing ssh-keys to User root"
mkdir -p /root/.ssh
chmod 700 /root/.ssh

touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

curl ${PACKER_HTTP_ADDR}/authorized_keys >> /root/.ssh/authorized_keys
curl ${PACKER_HTTP_ADDR}/resize-root.sh >> /root/resize-root.sh
chmod a+x /root/resize-root.sh

echo "Disable empty password login"
sed -i 's/#\?\(PermitEmptyPasswords\s*\).*$/\1 no/' /etc/ssh/sshd_config
echo "Disable password login"
sed -i 's/#\?\(PasswordAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config
echo "Disable PAM"
sed -e 's/#\?\(UsePAM\s*\).*$/\1 no/' -i /etc/ssh/sshd_config