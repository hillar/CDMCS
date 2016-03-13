#!/bin/bash
#
# This script will install bro master
# and set up ssh keys on workers and proxy's
#
# ! depends on salt
#

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
# salt '*' cmd.run 'setcap "CAP_NET_RAW+eip" /opt/bro/bin/bro'
# su - bro -s /bin/bash -c '/opt/bro/bin/broctl install'

adduser bro --disabled-login
mkdir /opt/bro/.ssh
chown -R bro:bro /opt/bro
ssh-keygen -t rsa -k /opt/bro/.ssh/id_rsa
chown -R bro:bro /opt/bro
