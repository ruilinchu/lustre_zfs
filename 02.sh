#!/bin/bash

yum install --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release.el7.noarch.rpm -y
yum install zfs-0.6.4.2 -y
modprobe zfs
echo zfs > /etc/modules-load.d/zfs.conf

yum install /var/tmp/vagrant/rpms/server/*.rpm -y

cat > /etc/hosts <<EOF
10.0.15.11 test1
10.0.15.12 test2
EOF

echo "options lnet networks=tcp0(enp0s8)" >> /etc/modprobe.d/lustre.conf

##lustre device config file, test2 is the server hostname
cat >> /etc/ldev.conf <<EOF
test2 - mgs     zfs:lustre-mgt0/mgt0
test2 - mdt     zfs:lustre-mdt0/mdt0
test2 - ost0    zfs:lustre-ost0/ost0
test2 - ost1    zfs:lustre-ost1/ost1
EOF

## make lustre disks
dd if=/dev/zero of=/var/tmp/lustre-mgt-disk0 bs=1M count=1 seek=256
dd if=/dev/zero of=/var/tmp/lustre-mdt-disk0 bs=1M count=1 seek=256
dd if=/dev/zero of=/var/tmp/lustre-ost-disk0 bs=1M count=1 seek=4095
dd if=/dev/zero of=/var/tmp/lustre-ost-disk1 bs=1M count=1 seek=4095

MyIP=10.0.15.12

mkfs.lustre --mgs --backfstype=zfs lustre-mgt0/mgt0 /var/tmp/lustre-mgt-disk0
mkfs.lustre --mdt --backfstype=zfs --index=0 --mgsnode=${MyIP}@tcp --fsname lustrefs lustre-mdt0/mdt0 /var/tmp/lustre-mdt-disk0
mkfs.lustre --ost --backfstype=zfs --index=0 --mgsnode=${MyIP}@tcp --fsname lustrefs lustre-ost0/ost0 /var/tmp/lustre-ost-disk0
mkfs.lustre --ost --backfstype=zfs --index=1 --mgsnode=${MyIP}@tcp --fsname lustrefs lustre-ost1/ost1 /var/tmp/lustre-ost-disk1

zpool list

systemctl start lustre
