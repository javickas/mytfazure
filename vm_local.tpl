


#!/bin/bash
sudo hostnamectl set-hostname ${name}
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo echo 'ubuntu: "var.az_linux_password" | /usr/sbin/chpasswd
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y iperf3
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools
sudo apt autoremove
sudo /etc/init.d/ssh restart


