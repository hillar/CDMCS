#!/bin/bash
#
# This script will install ..

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

echo "got arg1: $1  arg2: $2"
# got arg1: 192.168.11.31,192.168.11.32  arg2: 192.168.11.41

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
sed 'wget '
sed -i -e 's,wget,wget -N -P /var/cache/wget -4 -q,g' easybutton-build.sh
./easybutton-build.sh --dir /opt/moloch > /dev/null 2>&1
make install > /dev/null 2>&1

#create a dummy config file
mkdir -p /opt/moloch/etc/
cp single-host/etc/config.ini.template /opt/moloch/etc/config.ini.template
echo -en "\n\n\n\n\n" | ./easybutton-config.sh /opt/moloch

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

echo "done compiling and deps and dummy conf"
echo "captures: $1"
echo "viewers:  $2"


#/opt/moloch/db/db.pl 192.168.11.41:9200 info
#/opt/moloch/db/db.pl 192.168.11.41:9200 init

#/opt/moloch/bin/moloch-capture --help
