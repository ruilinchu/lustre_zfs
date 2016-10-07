#!/bin/bash

yum install --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release.el7.noarch.rpm -y
yum install zfs-0.6.4.2 -y
modprobe zfs
echo zfs > /etc/modules-load.d/zfs.conf

yum install /var/tmp/vagrant/rpms/server/*.rpm -y

cat > /etc/hosts <<EOF
10.0.15.11 server1
10.0.15.12 server2
10.0.15.13 server3
EOF

echo "options lnet networks=tcp0(enp0s8)" >> /etc/modprobe.d/lustre.conf

cp -fr /var/tmp/vagrant/ldev.conf /etc/ldev.conf

MGSIP=10.0.15.11
luid=$(( $(hostname -s | cut -c7-) - 1 ))

if [[ $luid == 0 ]]; then
    dd if=/dev/zero of=/var/tmp/lustre-mgt-disk0 bs=1M count=1 seek=512
    mkfs.lustre --mgs --backfstype=zfs lustre-mgt0/mgt0 /var/tmp/lustre-mgt-disk0
fi

dd if=/dev/zero of=/var/tmp/lustre-mdt-disk0 bs=1M count=1 seek=512
mkfs.lustre --mdt --backfstype=zfs --index=$luid --mgsnode=${MGSIP}@tcp --fsname lustrefs lustre-mdt$luid/mdt$luid /var/tmp/lustre-mdt-disk0
mkfs.lustre --ost --backfstype=zfs --index=$luid --mgsnode=${MGSIP}@tcp --fsname lustrefs lustre-ost$luid/ost$luid raidz1 /dev/sdb /dev/sdc /dev/sdd

zpool list

#systemctl start lustre
