
git config --global http.sslverify false

# The followed part should be run on root account
service libvirt-bin restart
chmod a+rw /var/run/libvirt/libvirt-sock
/usr/sbin/virtlogd -d
chmod a+rw /var/run/libvirt/virtlogd-sock
echo "12" > /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
echo "12" > /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/nr_hugepages

mkdir -p /mnt/hugetlbfs-1g
sudo mount -t hugetlbfs hugetlbfs /mnt/hugetlbfs-1g

#sudo /sbin/sysctl net.ipv4.conf.p1p1.forwarding=1
#sudo iptables -t nat -A POSTROUTING -o p1p1 -j MASQUERADE
