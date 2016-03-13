#!/bin/bash
#
# This script will install bro master
# and set up ssh keys on workers and proxy's
#
# ! depends on salt
#
# params :
# $1 salt key pattern to match bro workers and proxyes
# $2 workers ip list, sepatarated with comma
# $3 proxyes ip list, sepatarated with comma

echo "installing bro with:"
echo "pattern: $1"
echo "workers: $2"
echo "proxyes: $3"
echo "wait .."

## step-by-step (semi)manual version with salt
## taken from bash history, expect mistakes
## those commands are meant to be executed on saltmaster (also bro master)
## salt master is also a minion to itself
# salt '*' cmd.run 'echo "deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/ /" >> /etc/apt/sources.list.d/bro.list'
# salt '*' cmd.run 'wget http://download.opensuse.org/repositories/network:bro/xUbuntu_14.04/Release.key'
# salt '*' cmd.run 'apt-key add - < Release.key'
# salt '*' cmd.run 'apt-get update'
# salt '*' pkg.install bro
# salt '*' cmd.run 'useradd bro -N'
# salt '*' cmd.run 'usermod -d /opt/bro bro'
# salt '*' cmd.run 'mkdir /opt/bro/.ssh && chown -R bro:bro /opt/bro && chmod 750 /opt/bro/.ssh'
# su - bro -s /bin/bash -c 'ssh-keygen -t rsa -f /opt/bro/.ssh/id_rsa'
# salt '*' cmd.run "echo \"`cat /opt/bro/.ssh/id_rsa.pub`\" >> /opt/bro/.ssh/authorized_keys"
# salt '*' cmd.run 'chown -R bro:bro /opt/bro'
# <vim /opt/bro/etc/node.cfg>
# <accept ssh fingerprints or set up .ssh/config to insecure/autoaccept>
# salt '*' cmd.run 'setcap "CAP_NET_RAW+eip" /opt/bro/bin/bro'
# su - bro -s /bin/bash -c '/opt/bro/bin/broctl install'


# add bro repo and install
echo "deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/ /" >> /etc/apt/sources.list.d/bro.list
wget http://download.opensuse.org/repositories/network:bro/xUbuntu_14.04/Release.key
apt-key add - < Release.key
apt-get update
apt-get install bro
#prepare for master setup
useradd bro -N
usermod -d /opt/bro bro
mkdir /opt/bro/.ssh && chown -R bro:bro /opt/bro && chmod 750 /opt/bro/.ssh
su - bro -s /bin/bash -c 'echo -en "\n\n"|ssh-keygen -t rsa -f /opt/bro/.ssh/id_rsa'
#cat /opt/bro/.ssh/id_rsa.pub >> /opt/bro/.ssh/authorized_keys
KEY=$(cat /opt/bro/.ssh/id_rsa.pub)
salt "*$1*" cmd.run 'echo "$KEY" >> /opt/bro/.ssh/authorized_keys;chown -R bro:bro /opt/bro;'
su - bro -s /bin/bash -c '/opt/bro/bin/broctl install'

# test
# USER='bro'
# HOSTNAME="10.242.11.12"
# su - bro -s /bin/bash -c 'scp ~/.ssh/id_rsa.pub $USER@$HOSTNAME:~/''
