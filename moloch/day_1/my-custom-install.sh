#!/bin/bash
#
# This script will install ..

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

echo "got arg1: $1  arg2: $2"


mkdir -p /vagrant/provision
cd /vagrant/provision

if [ ! -f "master.tar.gz" ]; then
    echo "downloading moloch source..."
    time wget -4 -q https://github.com/aol/moloch/archive/master.tar.gz
fi

ES=2.3.2
if [ ! -f "elasticsearch-${ES}.deb" ]; then
  echo "downloaging elastic $ES"
  wget -4 -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ES}.deb
fi

echo "using: "
for i in $(ls);
do
  ls -tlah $i
done

#mkdir -p /build
#cd /build/
#tar -xzf /vagrant/provision/master.tar.gz
#cd moloch-master/
#ls -tlah

# https://github.com/aol/moloch/blob/16e21a275eef042f635686213247e8cde4729754/capture/reader-libpcap.c#L58
# ethtool -K INTERFACE tx off sg off gro off gso off lro off tso off
