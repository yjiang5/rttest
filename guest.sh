#!/bin/bash

cd ~/source/dpdk/
sudo modprobe uio
sudo insmod x86_64-native-linuxapp-gcc/kmod/igb_uio.ko
sudo tools/dpdk_nic_bind.py -b igb_uio 00:05.0
sudo tools/dpdk_nic_bind.py -b igb_uio 00:06.0

sudo examples/skeleton/build/basicfwd -l1 -b 00:03.0
