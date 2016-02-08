#!/bin/bash
#
# this script
# will build moloch
#


if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

echo "going to build moloch, take your time, or coffe or ..."

IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
INSTALL_DIR=/provision

mkdir -p ${INSTALL_DIR}/moloch
cd ${INSTALL_DIR}/moloch
if [ ! -f "master.tar.gz" ]; then
   wget -4 -q https://github.com/aol/moloch/archive/master.tar.gz
   tar -xzf master.tar.gz
fi
cd moloch-master

#echo -e "\n\n\n\n\n\n\n\n"|./easybutton-singlehost.sh
