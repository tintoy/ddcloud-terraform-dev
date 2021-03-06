#!/bin/bash

# Package repositories
apt-get update
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
add-apt-repository -y ppa:ubuntu-lxc/lxd-stable

# Basics
apt-get update
apt-get install -y build-essential git zsh python-dev python-pip
echo 'source /root/.profile' >> /root/.zshenv
git config --global credential.helper 'store'

# Go
curl -o /root/golang.tar.gz https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz
tar -C /usr/local -xvzf /root/golang.tar.gz
rm /root/golang.tar.gz
mkdir -p /root/go
echo '' >> /root/.profile
echo '# Go' >> /root/.profile
echo 'export GOROOT=/usr/local/go' >> /root/.profile
echo 'export GOPATH=/root/go' >> /root/.profile
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /root/.profile
source /root/.profile

# Terraform
echo 'Fetching Terraform...'
go get -u github.com/hashicorp/terraform
cd /root/go/src/github.com/hashicorp/terraform
git checkout v0.8.0-rc3
echo 'Building Terraform...'
make dev

# CloudControl plugin for Terraform
echo 'Fetching CloudControl plugin for Terraform...'
mkdir -p /root/go/src/github.com/DimensionDataResearch/dd-cloud-compute-terraform
cd /root/go/src/github.com/DimensionDataResearch/dd-cloud-compute-terraform
git clone --recursive https://github.com/DimensionDataResearch/dd-cloud-compute-terraform.git .
echo 'Building CloudControl plugin for Terraform...'
make clean dev

# Ansible
echo 'Installing Ansible...'
apt-get install -y ansible

echo 'Done!'
