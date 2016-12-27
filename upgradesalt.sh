#!/bin/bash
## make apt not fail when config files have been modified
export DEBIAN_FRONTEND=noninteractive
## Add Saltstack repo gpg key
wget -O - https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
## Add Saltstack repo to apt sources
echo "deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main" > /tmp/saltstack.list
sudo mv /tmp/saltstack.list /etc/apt/sources.list.d/saltstack.list
## Add priority in apt for Saltstack repo
echo -e "\
Package: *
Pin: origin repo.saltstack.com
Pin-Priority: 1002" > /tmp/saltstack.pref
sudo mv /tmp/saltstack.pref /etc/apt/preferences.d/saltstack.pref
## Upgrade salt-minion to latest version available in Saltstack repo
sudo apt-get update
sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install salt-minion
sudo apt-get autoremove -y
