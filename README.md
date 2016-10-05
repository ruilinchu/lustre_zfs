```
centos7.2
lustre 2.8
zfs 0.6.4.2

server

[root@test2 vagrant]# zpool list
NAME          SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
lustre-mdt0   252M  2.81M   249M         -     1%     1%  1.00x  ONLINE  -
lustre-mgt0   252M  2.09M   250M         -     1%     0%  1.00x  ONLINE  -
lustre-ost0  3.97G  2.30M  3.97G         -     0%     0%  1.00x  ONLINE  -
lustre-ost1  3.97G  2.30M  3.97G         -     0%     0%  1.00x  ONLINE  -

mount:

lustre-mgt0/mgt0 on /mnt/lustre/local/mgs type lustre (ro)
lustre-ost0/ost0 on /mnt/lustre/local/ost0 type lustre (ro)
lustre-ost1/ost1 on /mnt/lustre/local/ost1 type lustre (ro)
lustre-mdt0/mdt0 on /mnt/lustre/local/mdt type lustre (ro)


client mount:

[root@test1 vagrant]# mount -t lustre test2@tcp:/lustrefs /lustre
[root@test1 vagrant]# mount
10.0.15.12@tcp:/lustrefs on /lustre type lustre (rw)

```
