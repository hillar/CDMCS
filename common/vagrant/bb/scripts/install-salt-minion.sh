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
#echo "${MASTER} saltmaster" >> /etc/hosts
#hostname `cat /etc/hostname`
add-apt-repository -y ppa:saltstack/salt > /dev/null
apt-get update > /dev/null
apt-get -y install salt-minion > /dev/null
echo "master: ${MASTER}" >> /etc/salt/minion
service salt-minion restart
sleep 1
tail /var/log/salt/minion
