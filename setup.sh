#!/bin/bash

mkdir ~/.ssh
chmod 700 ~/.ssh

# on the controller node
#ssh-keygen -t rsa
#cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
#scp ~/.ssh/* root@172.24.1.4:/tmp/
#scp ~/.ssh/* root@172.24.1.5:/tmp/


# on the compute node
#sudo chmod a+rw /tmp/id_rsa*
#cp /tmp/authorized_keys ~/.ssh/
#cp /tmp/id_rsa* ~/.ssh/
#chmod 600 ~/.ssh/id_rsa
#chmod 600 ~/.ssh/authorized_keys
