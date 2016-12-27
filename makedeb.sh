#!/bin/bash
## Variables
vendor="HashiCorp"
distro="debian"
distroversion="jessie"
## Determine if variables are empty
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Packages up $vendor application binaries into .deb files."
  echo "Usage: bash $0 <application> <version>"
  exit 1
fi
## Detect application to be packaged
if [ "$1" == "consul" ]; then
  url="https://consul.io"
  description="A distributed highly available tool for service discovery, configuration and orchestration"
  licence="MPL-2.0"
elif [ "$1" == "nomad" ]; then
  url="https://nomadproject.io"
  description="A cluster manager and scheduler to deploy applications across any infrastructure"
  licence="MPL-2.0"
else
  echo "Error: unknown application"
  exit 1
fi
## Install Ruby
echo "Installing dependencies..."
sudo apt-get install -y ruby-dev build-essential unzip
## Install FPM
echo "Installing FPM..."
sudo gem install fpm
echo "Installing package_cloud CLI client..."
## Download application binary
echo "Downloading $1 application binary..."
wget -N https://releases.hashicorp.com/$1\/$2\/$1\_$2\_linux_amd64.zip
## Unzip application binary
echo "Unzipping $1 application binary..."
unzip $1\/$2\/$1\_$2\_linux_amd64.zip
## Run FPM
echo "Running FPM..."
fpm --force --verbose -s dir -t deb -n $1 -v $2 \--url\=$url \--vendor\=$vendor  --description \"$description\" \--license\=$licence ./consul\=/usr/local/bin/consul
## Upload .deb to packagecloud
echo "Uploading .deb package to packagecloud..."
package_cloud push tom29739/captcha/$distro\/$distroversion $1\_$2\_amd64.deb
## Done
echo "Package for $1 v$2 created and uploaded to packagecloud repo."
exit 0
