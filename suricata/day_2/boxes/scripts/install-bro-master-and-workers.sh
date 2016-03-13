#!/bin/bash
#
# This script will install bro master
# and set up ssh keys on workers and proxy's
#
# ! depends on salt
#


adduser bro --disabled-login
mkdir /opt/bro/.ssh
chown -R bro:bro /opt/bro
ssh-keygen -t rsa -k /opt/bro/.ssh/id_rsa
chown -R bro:bro /opt/bro
