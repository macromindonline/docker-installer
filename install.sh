#!/bin/bash

##########################################
# Script to install docker on ubuntu server
# idc at macromind dot online
##########################################
set -e

if [[ "$(id -u)" != "0" ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [[ ${1} == "" || ${2} == "" ]] ; then
    echo 'Please, inform the mail server hostname and admin password. e.g. ./install.sh mail.mydomain.com p4ssw0rd'
    exit 0
fi

echo "==============================================="
echo "Setting variables and hostname"
DOCKER_HOSTNAME=docker-node-${RANDOM}
hostnamectl set-hostname ${DOCKER_HOSTNAME} &>/dev/null

echo "Updating apt packages…"
apt update &>/dev/null && apt dist-upgrade -y
apt install vim-nox htop atop nload ncdu pv netcat build-essential apt-transport-https ca-certificates software-properties-common curl dnsutils tmux -y &>/dev/null

echo "Installing Docker CE"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - &>/dev/null
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" &>/dev/null
apt update &>/dev/null && apt install docker-ce -y &>/dev/null

echo "Installing Docker Compose"
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>/dev/null
if [[ -f "/usr/local/bin/docker-compose" ]]; then
    chmod 700 /usr/local/bin/docker-compose
else
    echo "Docker compose not installed..."
    exit 1
fi

echo "All done…"
echo "==============================================="
