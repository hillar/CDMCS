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
# $3 proxyes ip list, sepatarated with comma
# $4 workers ip list, sepatarated with comma


if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

echo "installing bro with:"
echo "manager: $1"
echo "pattern: $2"
echo "proxyes: $3"
echo "workers: $4"
echo "wait .."

MANAGER=$1
BROS=$2
PROXYS=$3
WORKERS=$4


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
# create node.cfg
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

echo "$WORKERS" | sed 's/,/\n/g'|while read IP;
do
  echo "[worker-$IP]" >> /opt/bro/etc/node.cfg
  echo "type=worker" >> /opt/bro/etc/node.cfg
  echo "host=$IP" >> /opt/bro/etc/node.cfg
done

#su - bro -s /bin/bash -c '/opt/bro/bin/broctl deploy'
