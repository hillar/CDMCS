#!/bin/bash
#
# this script
# 1) adds ppa:saltstack/salt
# 2) installs salt-master
# 3) accepts all minions contacting in 10 secs
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

echo "installing salt-master on ${hostname} ..."

echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4
add-apt-repository -y ppa:saltstack/salt 2>&1 > /dev/null
apt-get update 2>&1 > /dev/null
apt-get -y install salt-master 2>&1 > /dev/null
#echo "waiting for minions.."
#sleep 11
#salt-key -L
#salt-key -A -y
#sleep 3
#salt '*' test.ping
