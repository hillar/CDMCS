#!/bin/bash
#
# this script:
# 1) installs grafana
#
#

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi


IP=$(ifconfig eth0 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)

echo "installing grafana on ${IP} ${HOSTNAME} ..."

INSTALL_DIR=/provision


GRFN="2.6.0"
mkdir -p ${INSTALL_DIR}/grafana
cd ${INSTALL_DIR}/grafana
if [ ! -f "grafana_${GRFN}_amd64.deb" ]; then
  wget -q https://grafanarel.s3.amazonaws.com/builds/grafana_${GRFN}_amd64.deb
fi
if [ ! -f "grafana_${GRFN}_amd64.deb" ]; then
  echo "$(date) ${HOSTNAME} $0[$$]: {grafana: {status:WARNING, msg: missing grafana_${GRFN}_amd64.deb}"
  #exit -1
else
  apt-get install -y adduser libfontconfig
  echo -e "Y"|dpkg -i grafana_${GRFN}_amd64.deb
  update-rc.d grafana-server defaults 95 10
  sed -i -e 's,domain = localhost,domain = '${IP}',g' /etc/grafana/grafana.ini
  service grafana-server start
fi
