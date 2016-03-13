#!/bin/bash
#
# This script will install bro master
# and set up ssh keys on workers and proxy's
#
# ! depends on salt
#
# params :
# $1 manager ip
# $2 salt key pattern to match bro workers and proxyes
# $3 workers ip list, sepatarated with comma
# $4 proxyes ip list, sepatarated with comma

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

echo "installing bro with:"
echo "manager: $1"
echo "pattern: $2"
echo "workers: $3"
echo "proxyes: $4"
echo "wait .."

MANAGER=$1
BROS=$2
WORKERS=$3
PROXYS=$4

BROS="student-1-bro-worker-b"

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
wget -4 -q http://download.opensuse.org/repositories/network:bro/xUbuntu_14.04/Release.key
apt-key add - < Release.key  > /dev/null 2>&1
apt-get -qq update  > /dev/null 2>&1
apt-get -y install bro  > /dev/null 2>&1
#prepare master key
useradd bro -N  > /dev/null 2>&1
usermod -d /opt/bro bro  > /dev/null 2>&1
mkdir /opt/bro/.ssh && chown -R bro:bro /opt/bro && chmod 750 /opt/bro/.ssh
su - bro -s /bin/bash -c 'echo -en "\n\n"|ssh-keygen -t rsa -f /opt/bro/.ssh/id_rsa'

salt-key -A -y
salt-key -L
sleep 1
salt-cp "*$BROS*" /opt/bro/.ssh/id_rsa.pub /tmp/br
salt "*$BROS*" cmd.run 'mkdir -p /opt/bro/.ssh'
salt "*$BROS*" cmd.run 'cat /tmp/br >> /opt/bro/.ssh/authorized_keys'
salt "*$BROS*" cmd.run 'addgroup --system bro --quiet'
salt "*$BROS*" cmd.run 'adduser --system --home /opt/bro --no-create-home --ingroup bro --disabled-password --shell /bin/false bro'
salt "*$BROS*" cmd.run 'chown -R bro:bro /opt/bro;'
salt "*$BROS*" cmd.run 'echo "10.242.11.10 student-1-manager" >> /etc/hosts'
# test

echo "$WORKERS" | sed 's/,/\n/g'|while read IP;
do
   su - bro -s /bin/bash -c 'ssh $IP'
done

cat > /opt/bro/etc/node.cfg<<DELIM
[manager]
type=manager
host=$MANAGER
DELIM

echo "$PROXYS" | sed 's/,/\n/g'|while read IP;
do
  echo "[proxy-$IP]" >> /opt/bro/etc/node.cfg
  echo "type=proxy" >> /opt/bro/etc/node.cfg
  echo "host=$IP" >> /opt/bro/etc/node.cfg
done

echo "$PROXYS" | sed 's/,/\n/g'|while read IP;
do
  echo "[worker-$IP]" >> /opt/bro/etc/node.cfg
  echo "type=worker" >> /opt/bro/etc/node.cfg
  echo "host=$IP" >> /opt/bro/etc/node.cfg
done

#[manager]
#type=manager
#host=host1
#
#[proxy-1]
#type=proxy
#host=host1
#
#[worker-1]
#type=worker
#host=host2
#interface=eth0
#
#[worker-2]
#type=worker
#host=host3
#interface=eth0

#su - bro -s /bin/bash -c '/opt/bro/bin/broctl deploy'
