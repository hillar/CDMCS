#!/bin/bash

# create and add updated & upgraded ubuntu 14 box to vagrant box list
# time 5-10ish minutes

# exit if ubu14 is listed as a box
if [ "$(vagrant box list|grep ubu14|awk '{print $1}')" = "ubu14" ]
then
  echo "ubu14 is already listed, nothing to do ;)"
  echo "simply run"
  echo "vagrant init ubu14"
  exit
fi

# exit if Vagrantfile exist
if [  -f "./Vagrantfile" ];
then
  echo "./Vagrantfile exist, exiting";
  exit
fi

# create ./Vagrantfile
cat > ./Vagrantfile <<DELIM
\$script = <<SCRIPT
echo "update & upgrade.."
date > /etc/vagrant_provisioned_at
apt-get update >> /etc/vagrant_provisioned_at
apt-get upgrade >> /etc/vagrant_provisioned_at
apt-get -y install openjdk-7-jdk >> /etc/vagrant_provisioned_at
apt-get clean
date >> /etc/vagrant_provisioned_at
SCRIPT
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "shell", inline: \$script
end
DELIM

# run & provision & package & add & clean up
vagrant up
vagrant halt
vagrant package --output ubu14.box
vagrant box add ubu14 ubu14.box
vagrant destroy -f
rm ./Vagrantfile
rm ./ubu14.box
rmdir -p .vagrant/machines/default/virtualbox/

if [ "$(vagrant box list|grep ubu14|awk '{print $1}')" = "ubu14" ]
then
  echo "ubu14 is now listed as available box, done"
  echo "simply run"
  echo "vagrant init ubu14"

fi
