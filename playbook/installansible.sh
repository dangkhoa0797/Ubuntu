#!/bin/bash

apt install python3-pip -y
pip3 install ansible
mkdir -p /etc/ansible/
printf '
ansible ansible_host=192.168.253.140 ansible_port=22 ansible_user=root

[reachable]
ubuntu202 ansible_host=192.168.253.139 ansible_port=22 ansible_user=root

[worker]
ubuntu201 ansible_host=192.168.253.138 ansible_port=22 ansible_user=root
' > /etc/ansible/hosts
