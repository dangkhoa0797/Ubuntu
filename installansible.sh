#!/bin/bash
sudo -i
apt install python3-pip -y
pip3 install ansible
mkdir -p /etc/ansible/
printf '
manager-leader ansible_host=192.168.253.161 ansible_port=22 ansible_user=root

[reachable]
manager1 ansible_host=192.168.253.161 ansible_port=22 ansible_user=root

[worker]
worker1 ansible_host=192.168.253.161 ansible_port=22 ansible_user=root
' > /etc/ansible/hosts
