#!/bin/bash
echo "$0 got params: $1 $2 $3 $4"



cd /tmp
wget -q https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz
mkdir /opt
cd /opt/
tar -xzf /tmp/kibana-4.3.1-linux-x64.tar.gz
ln -sf /opt/kibana-4.3.1-linux-x64 /opt/kibana
/opt/kibana/bin/kibana plugin -i kibana/timelion
#chown -R kibana.kibana /opt/kibana/optimize/
/opt/kibana/bin/kibana > /var/log/kibana.log 2>&1 &
