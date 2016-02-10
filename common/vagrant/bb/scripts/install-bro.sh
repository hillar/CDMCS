#!/bin/bash


echo 'deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/bro.list
sudo apt-get update
sudo apt-get install bro
