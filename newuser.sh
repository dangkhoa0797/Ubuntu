#!/bin/bash
useradd -c "khoa" -m khoa
echo "khoa:dangkhoabro9x" | chpasswd
echo "khoa	ALL=(ALL:ALL) ALL" >> /etc/sudoers
sudo groupadd docker
sudo usermod -aG docker khoa
