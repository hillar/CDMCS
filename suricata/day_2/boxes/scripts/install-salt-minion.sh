#!/bin/bash
#
# this script
# 1) adds ppa:saltstack/salt
# 2) installs salt-minion
# 3) sets master to $1

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

MASTER=$1
IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)
echo "installing salt-minion on ${IP} ${HOSTNAME} setting master to ${MASTER}..."
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4
add-apt-repository -y ppa:saltstack/salt > /dev/null 2>&1
apt-get update  > /dev/null 2>&1
apt-get -y install salt-minion  > /dev/null 2>&1
service salt-minion stop > /dev/null 2>&1
echo "master: ${MASTER}" > /etc/salt/minion
echo "id: ${HOSTNAME}" >> /etc/salt/minion
service salt-minion start > /dev/null 2>&1
sleep 1
service salt-minion status
