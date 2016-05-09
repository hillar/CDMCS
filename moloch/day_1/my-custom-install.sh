#!/bin/bash
#
# This script will install ..

if [ "$(id -u)" != "0" ]; then
   echo "ERROR - This script must be run as root" 1>&2
   exit 1
fi

echo "got arg1: $1  arg2: $2"
