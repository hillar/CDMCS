#!/bin/bash
#
# This script will install ..

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

IPADMIN=$1
CAPTURES=$2
VIEWERS=$3

mkdir -p /var/cache/wget
cd /var/cache/wget
if [ ! -f "master.tar.gz" ]; then
    echo "downloading moloch source..."
    wget -N -P /var/cache/wget -4 -q https://github.com/aol/moloch/archive/master.tar.gz
fi
if [ ! -f "master.tar.gz" ]; then
  echo "cant get https://github.com/aol/moloch/archive/master.tar.gz ;("
  exit -1
fi
mkdir -p /tmp/building
cd /tmp/building
tar -xzf /var/cache/wget/master.tar.gz
cd moloch-master/
apt-get -y install nodejs npm > /dev/null 2>&1
echo "compiling moloch from source... "

#sed -i -e 's,wget http,wget -N -P /var/cache/wget -4 -q http,g' easybutton-build.sh
./easybutton-build.sh --dir /opt/moloch > /dev/null 2>&1
make install > /dev/null 2>&1

#create a dummy config file
mkdir -p /opt/moloch/etc/
cp single-host/etc/config.ini.template /opt/moloch/etc/config.ini.template
echo -en "\n\n\n\n\n" | ./easybutton-config.sh /opt/moloch
# "edit" config, disable https
sed -i -e 's,certFile,#certFile,g' /opt/moloch/etc/config.ini
sed -i -e 's,keyFile,#keyFile,g' /opt/moloch/etc/config.ini
# add nodes ..
echo "## capture nodes created by $0 $(date)" >> /opt/moloch/etc/config.ini
for i in $(echo "$CAPTURES"| sed 's/,/\n/g'); do
nodeip=$(echo $i|cut -f1 -d";")
nodename=$(echo $i|cut -f2 -d";")
salt "$nodename" cmd.run "ethtool -K eth0 tx off sg off gro off gso off lro off tso off"
cat >> /opt/moloch/etc/config.ini<<EOF
[$nodename]
rotateIndex=hourly
interface=eth0;eth1
elasticsearch=$nodeip:9200
plugins=wise.so
wiseHost=$IPADMIN
EOF
done
echo "## viewer nodes created by $0 $(date)" >> /opt/moloch/etc/config.ini
for i in $(echo "$VIEWERS"| sed 's/,/\n/g'); do
nodeip=$(echo $i|cut -f1 -d";")
nodename=$(echo $i|cut -f2 -d";")
cat >> /opt/moloch/etc/config.ini<<EOF
[$nodename]
elasticsearch=$nodeip:9200
EOF
done

NODEJS=0.10.45

cd /var/cache/wget
if [ ! -f "node-v${NODEJS}.tar.gz" ]; then
  echo "Downloading  node"
  wget -N -P /var/cache/wget -4 -q http://nodejs.org/dist/v${NODEJS}/node-v${NODEJS}.tar.gz
fi
echo "complining nodejs"
cd /tmp/building
tar xfz /var/cache/wget/node-v${NODEJS}.tar.gz
cd node-v${NODEJS}
./configure --prefix=/opt/moloch > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1

#download dep's
cd /opt/moloch/etc/
wget -N -P /var/cache/wget -4 -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
cp /var/cache/wget/GeoIP.dat.gz .
gunzip GeoIP.dat.gz
wget -N -P /var/cache/wget -4 -q http://www.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
cp /var/cache/wget/GeoIPASNum.dat.gz .
gunzip GeoIPASNum.dat.gz
wget -N -P /var/cache/wget -4 -q https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv
cp /var/cache/wget/ipv4-address-space.csv .

echo "done compiling and deps and dummy conf, creating tarball.."

#start elastic before tarball...
salt-key -A -y > /dev/null 2>&1
sleep 1
salt "*" test.ping > /dev/null 2>&1
salt "*" test.ping > /dev/null 2>&1
salt "*" service.start elasticsearch > /dev/null 2>&1
salt -E '(viewer|moloch)-*' cmd.run "apt-get -y install nodejs > /dev/null " > /dev/null 2>&1

#create tarball and load it to nodes
mkdir -p /var/www
cd /opt/moloch
tar cvfz /var/www/moloch_and_nodejs.tgz --exclude /opt/moloch/elasticsearch* --exclude /opt/moloch/data /opt/moloch/ > /dev/null 2>&1
cd /var/www
python -m SimpleHTTPServer &
salt -E '(viewer|moloch)-*' cmd.run "wget -q $IPADMIN:8000/moloch_and_nodejs.tgz" > /dev/null 2>&1
salt -E '(viewer|moloch)-*' cmd.run "tar -xzf moloch_and_nodejs.tgz" > /dev/null 2>&1
salt -E '(viewer|moloch)-*' cmd.run "mv opt/ /" > /dev/null 2>&1
salt "moloch-*" cmd.run "mkdir -p /opt/moloch/raw" > /dev/null 2>&1
salt "moloch-*" cmd.run "chown daemon /opt/moloch/raw" > /dev/null 2>&1
salt -E '(viewer|moloch)-*' cmd.run "mkdir -p /opt/moloch/logs" > /dev/null 2>&1
salt -E '(viewer|moloch)-*' cmd.run "chown daemon /opt/moloch/logs" > /dev/null 2>&1

#create upstart conf files
cat > /etc/init/moloch-capture.conf<<EOF
description "Upstart configuration for Capture"
start on started elasticsearch
stop on stopping elasticsearch
respawn limit 10 5
env CAPTURE_HOME=/opt/moloch/

pre-start script
  chdir \$CAPTURE_HOME
  exec /bin/rm -f \$CAPTURE_HOME/logs/capture.log.old
  exec /bin/mv \$CAPTURE_HOME/logs/capture.log \$CAPTURE_HOME/logs/capture.log.old
end script

script
  chdir \$CAPTURE_HOME
  exec \$CAPTURE_HOME/bin/moloch-capture -c \$CAPTURE_HOME/etc/config.ini > \$CAPTURE_HOME/logs/capture.log 2>&1
end script
EOF
salt-cp "moloch-*" /etc/init/moloch-capture.conf /etc/init/moloch-capture.conf > /dev/null 2>&1
salt "moloch-*" service.status moloch-capture > /dev/null 2>&1

cat > /etc/init/moloch-viewer.conf<<EOF
description "Upstart configuration for Viewer"
start on started elasticsearch
stop on stopping elasticsearch
respawn limit 10 5
env VIEWER_HOME=/opt/moloch/
export NODE_ENV=production

pre-start script
  chdir \$VIEWER_HOME/viewer
  exec /bin/rm -f \$VIEWER_HOME/logs/viewer.log.old
  exec /bin/mv \$VIEWER_HOME/logs/viewer.log $VIEWER_HOME/logs/viewer.log.old
end script

script
  chdir \$VIEWER_HOME/viewer
  exec ../bin/node viewer.js -c \$VIEWER_HOME/etc/config.ini > \$VIEWER_HOME/logs/viewer.log 2>&1
end script
EOF
salt-cp -E "(viewer|moloch)-*" /etc/init/moloch-viewer.conf /etc/init/moloch-viewer.conf > /dev/null 2>&1
salt -E "(viewer|moloch)-*" service.status moloch-viewer > /dev/null 2>&1

#setting up wiseservice
mkdir -p /opt/moloch/wiseService/logs
chown daemon /opt/moloch/wiseService/logs
cat > /opt/moloch/wiseService/wiseService.ini<<EOF
[wiseService]
port=8081
excludeDomains=*.bl.barracudabrts.com;*.zen.spamhaus.org;*.in-addr.arpa;*.avts.mcafee.com;*.avqs.mcafee.com;*.bl.barracuda.com;*.lbl8.mailshell.net;*.dnsbl.sorbs.net;*.s.sophosxl.nt
#[file:blah]
#file=/tmp/test.ips
#type=ip
#tags=TAG1,TAG2
[url:zeus.ips]
url=https://zeustracker.abuse.ch/blocklist.php?download=ipblocklist
tags=zeustracker,botnet
type=ip
reload=600
[url:zeus.domain]
url=https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
tags=zeustracker,botnet
type=domain
reload=600
EOF
cat > /etc/init/moloch-wiseservice.conf<<EOF
description "Upstart configuration for WiseService"
respawn limit 10 5
env WISE_HOME=/opt/moloch/wiseService
export NODE_ENV=production

pre-start script
  chdir \$WISE_HOME
  exec /bin/rm -f \$WISE_HOME/logs/wise.log.old
  exec /bin/mv \$WISE_HOME/logs/wise.log $WISE_HOME/logs/wise.log.old
end script

script
  chdir \$WISE_HOME
  exec ../bin/node wiseService.js -c \$WISE_HOME/wiseService.ini > \$WISE_HOME/logs/wise.log 2>&1
end script
EOF


#init db schema
until curl -sS "http://$IPADMIN:9200/_cluster/health?wait_for_status=yellow&timeout=5s" >  /dev/null 2>&1
do
    echo "Waiting for ES to start"
    sleep 3
done
echo
curl -XDELETE $IPADMIN:9200/*
/opt/moloch/db/db.pl $IPADMIN:9200 init
/opt/moloch/db/db.pl $IPADMIN:9200 info
cd /opt/moloch/viewer/
../bin/node addUser.js -c ../etc/config.ini admin "Admin" admin -admin
sleep 1
salt "moloch-*" service.start moloch-capture > /dev/null 2>&1
salt -E "(viewer|moloch)-*" service.start moloch-viewer > /dev/null 2>&1

echo "DONE ;)"
