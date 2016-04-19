#!/bin/bash
modprobe i40e
dhclient eth1
echo 1 > /proc/irq/default_smp_affinity
for irq in /proc/irq/* ; do
    if [ -d ${irq} ] ; then
        echo 0 > ${irq}/smp_affinity_list
        echo "${irq}/smp_affinity_list:"`cat ${irq}/smp_affinity_list`
    fi
done

#        linux   /boot/vmlinuz-4.1.10-rt10nfv root=UUID=ba850d9d-1348-44df-853f-e0f751961106 ro  console=tty1 console=ttyS0 isolcpus=1-3 nohz_full=1-3 rcu_nocbs=1-3 idle=poll intel_pstate=disable processor.max_cstate=1

#scp cloud@172.24.1.5:/tmp/i40e-1.4.25.tar.gz /tmp/

