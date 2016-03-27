#!/bin/bash
# MVGK-easybutton-singlehost.sh
# Use this script to create a single instance ubu 14 host for:
# Moloch
# VSRoom
# Telegraf
# Influxdb
# Grafana
# Elasticsearch
# Kibana
#
# for testing !
# you probably don't want to use this for a real deployment.


if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

ETH=$1
IP=$(ifconfig $ETH 2>/dev/null|grep 'inet addr'|cut -f2 -d':'|cut -f1 -d' ')
HOSTNAME=$(hostname -f)
MASTER=$IP
ELASTIC=$IP
NAME=$HOSTNAME
CLUSTER=$HOSTNAME
UNICASTHOSTS=$IP
BIND=$IP

echo "installing Moloch + .... on $IP"

#https://github.com/aol/moloch/archive/master.tar.gz
#https://github.com/aol/moloch/archive/v0.12.2.tar.gz


#MLCH="v0.12.22
MLCH="master"
INSTALL_DIR=/provision

mkdir -p ${INSTALL_DIR}/moloch
cd ${INSTALL_DIR}/moloch
if [ ! -f "${MLCH}.tar.gz" ]; then
    wget -4 -q wget https://github.com/aol/moloch/archive/${MLCH}.tar.gz
fi
if [ ! -f "${MLCH}.tar.gz" ]; then
    echo "$(date) ${NAME} $0[$$]: {moloch: {status:ERROR, msg: missing {MLCH}.tar.gz}"
    exit -1
else
  if [! -d ${MLCH} ]; then
    tar -xzf ${MLCH}.tar.gz
  fi
  cd ${MLCH}
  echo -en "\n\n\n\n"
  fi
fi
