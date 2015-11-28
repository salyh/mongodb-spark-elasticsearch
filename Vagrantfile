#!/bin/sh
$script = <<SCRIPT
rm -rf /vagrant/_elasticsearch
export DEBIAN_FRONTEND=noninteractive
echo "Update packages"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 > /dev/null 2>&1
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo killall -9 java > /dev/null 2>&1
sudo apt-get -yqq update > /dev/null 2>&1
sudo apt-get -yqq install virtualbox-guest-additions-iso > /dev/null 2>&1
echo "Install Java"
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections > /dev/null 2>&1
sudo apt-get -yqq install curl software-properties-common > /dev/null 2>&1
sudo add-apt-repository -y ppa:webupd8team/java > /dev/null 2>&1
sudo apt-get -yqq update > /dev/null 2>&1
sudo apt-get -yqq install autoconf libtool libssl-dev libkrb5-dev python-dev python-pip curl openssl wget git oracle-java8-installer oracle-java8-unlimited-jce-policy > /dev/null 2>&1
sudo apt-get -yqq install mongodb-org > /dev/null 2>&1
sudo service mongod status
sudo pip install pymongo
sudo /vagrant/populate_mongodb.py
su -c "/vagrant/setup.sh" vagrant
SCRIPT
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, guest: 5601, host: 5601
  config.vm.network :forwarded_port, guest: 9200, host: 9200

  config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "2", "--memory", "2048"]
  end
  config.vm.provision "shell", inline: $script
end
