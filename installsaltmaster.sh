#!/bin/bash
## Add Saltstack repo gpg key
wget -O - https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
## Add Saltstack repo to Apt sources
echo "deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main" > /tmp/saltstack.list
sudo mv /tmp/saltstack.list /etc/apt/sources.list.d/saltstack.list
## Add priority in Apt for Saltstack repo
echo -e "\
Package: *
Pin: origin repo.saltstack.com
Pin-Priority: 1002" > /tmp/saltstack.pref
sudo mv /tmp/saltstack.pref /etc/apt/preferences.d/saltstack.pref
## Upgrade salt-minion to latest version available in Saltstack repo
sudo apt-get update
sudo apt-get install salt-master -y
