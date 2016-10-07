#!/bin/bash

cp -r /vagrant /var/tmp/

yum remove kernel* -y
yum install kernel-3.10.0-327.3.1.el7 -y
yum install rpms/client/*.rpm -y
sed -i "/SELINUX=.*/c\SELINUX=disabled" /etc/selinux/config
reboot
