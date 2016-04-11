#!/bin/bash
    export ftp_proxy=http://proxy-us.intel.com:911
    export http_proxy=http://proxy-us.intel.com:911
    export https_proxy=https://proxy-us.intel.com:911
    export socks_proxy=http://proxy-us.intel.com:1080
    export no_proxy=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,127.0.0.0/8,134.134.0.0/16,172.16.0.0/20,172.25.0.0/16
    export GIT_PROXY_COMMAND=~/bin/socks-gw
    export PATH=~bin:$PATH

