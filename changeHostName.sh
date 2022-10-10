#!/bin/bash
#sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
read -p "Enter line : " ten
hostnamectl set-hostname $ten
hostnamectl
