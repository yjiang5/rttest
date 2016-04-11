#!/bin/bash

#sudo apt-get update
sudo apt-get install openssh-server -y
sudo apt-get install connect-proxy -y
sudo apt-get install socat -y
sudo apt-get install python-pip -y
sudo apt-get install git -y
sudo apt-get install git-core -y

        echo 'export GIT_PROXY_COMMAND=~/bin/socks-gw
export PATH=~bin:$PATH' >> ~/.bashrc

       mkdir -p ~/bin
       echo '#!/bin/sh
# $1 = hostname, $2 = port
proxy=proxy-socks.sc.intel.com
exec socat STDIO SOCKS4:$proxy:$1:$2' > ~/bin/git-proxy

        echo '#!/bin/sh

MODE="GNOME"
echo  $1 |grep "\.intel\.com$" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    connect $@
else
    connect -S proxy-socks.sc.intel.com:1080 $@
fi' > ~/bin/socks-gw

        chmod a+x ~/bin -R
    export ftp_proxy=http://proxy-us.intel.com:911
    export http_proxy=http://proxy-us.intel.com:911
    export https_proxy=https://proxy-us.intel.com:911
    export socks_proxy=http://proxy-us.intel.com:1080
    export no_proxy=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,127.0.0.0/8,134.134.0.0/16,172.16.0.0/20
    export GIT_PROXY_COMMAND=~/bin/socks-gw
    export PATH=~bin:$PATH
