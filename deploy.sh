#!/bin/bash
yum install epel-release -y
yum install ansible pdsh -y

cat >> /etc/hosts <<EOF

10.0.15.11 server1
10.0.15.12 server2
10.0.15.13 server3
10.0.15.21 client1
10.0.15.22 client2

EOF

cat > /etc/profile.d/pdsh.sh <<EOF
export PDSH_RCMD_TYPE='ssh'
export WCOLL='/etc/pdsh/machines'
EOF

mkdir -p /etc/pdsh
grep 10.0. /etc/hosts | awk '{print $2}' > /etc/pdsh/machines

ssh-keygen -t rsa
for i in `grep 10.0.15 /etc/hosts | awk '{print $2}'`; do
    ssh-keyscan $i;
done > ~/.ssh/known_hosts

ansible-playbook -i hosts ssh_key.yml --ask-pass

cp -fr /vagrant  /var/tmp/







