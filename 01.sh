#!/bin/bash

cp -r /vagrant /var/tmp/

yum remove kernel* -y
yum install rpms/server/kernel*.rpm
sed -i "/SELINUX=.*/c\SELINUX=disabled" /etc/selinux/config
reboot
