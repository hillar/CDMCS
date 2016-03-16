# cheating...

```
STUDENTNO=18
BROS="student-$STUDENTNO-bro-worker-b"
salt "*$BROS*" test.ping
salt "*$BROS*" cmd.run 'addgroup --system bro --quiet'
salt "*$BROS*" cmd.run 'adduser --system --home /opt/bro --no-create-home --ingroup bro --disabled-password --shell /bin/bash bro'
salt "*$BROS*" cmd.run 'mkdir -p /opt/bro/.ssh'
salt-cp "*$BROS*" /opt/bro/.ssh/id_rsa.pub /opt/bro/.ssh/bro-manager.pub
salt "*$BROS*" cmd.run 'cat /opt/bro/.ssh/bro-manager.pub >> /opt/bro/.ssh/authorized_keys'
cat /etc/hosts | grep -v 127| grep $(hostname) > /opt/bro/hosts
salt-cp "*$BROS*" /opt/bro/hosts /opt/bro/hosts
salt "*$BROS*" cmd.run 'cat /opt/bro/hosts >> /etc/hosts'
salt "*$BROS*" cmd.run 'chown -R bro:bro /opt/bro;'

echo "[worker-10.242.11.183]" >> /opt/bro/etc/node.cfg
echo "type=worker" >> /opt/bro/etc/node.cfg
echo "host=10.242.11.183" >> /opt/bro/etc/node.cfg
echo "interface=eth1" >> /opt/bro/etc/node.cfg

echo "Host 10.242.11.183" >> /opt/bro/.ssh/config
echo "  Hostname 10.242.11.183" >> /opt/bro/.ssh/config
echo "  IdentityFile ~/.ssh/id_rsa" >> /opt/bro/.ssh/config
echo "  StrictHostKeyChecking no" >> /opt/bro/.ssh/config

su - bro -s /bin/bash -c '/opt/bro/bin/broctl status'
su - bro -s /bin/bash -c '/opt/bro/bin/broctl deploy'
su - bro -s /bin/bash -c '/opt/bro/bin/broctl stop' 
salt "*$BROS*" cmd.run 'setcap "CAP_NET_RAW+eip" /opt/bro/bin/bro'
```
