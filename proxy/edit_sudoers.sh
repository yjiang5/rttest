#!/bin/sh
if [ -z "$1" ]; then
  echo "Starting up visudo with this script as first parameter"
  export EDITOR=$0 && sudo -E visudo
else
  echo "Changing sudoers"
  echo 'Defaults env_keep+="http_proxy no_proxy https_proxy ftp_proxy"' >> $1
fi
