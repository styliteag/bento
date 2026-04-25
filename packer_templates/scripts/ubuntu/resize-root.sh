#!/bin/sh -eux

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