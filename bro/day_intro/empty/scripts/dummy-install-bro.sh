#!/bin/bash
# this script
# 1) adds bro to atp sources
# 2) uodates debs list
# 3) installs bro from package

echo 'deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/bro.list
apt-get update
apt-get install bro
