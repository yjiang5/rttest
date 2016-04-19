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

