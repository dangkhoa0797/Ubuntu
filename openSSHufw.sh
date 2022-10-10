#!/bin/bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
#sudo ufw allow 80
#sudo ufw allow 443
sudo ufw --force enable
#yes | sudo ufw enable
#echo "y" | sudo ufw enable