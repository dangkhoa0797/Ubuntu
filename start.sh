#!/bin/bash

sudo apt-get install dialog
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="Install with ansible"
TITLE="Install swarm"
MENU="Choose one of the following options:"

OPTIONS=(1 "install ansible"
         2 "update file hosts --> /etc/ansible/hosts"
         3 "install manager leader *"
         4 "install manager reachable"
         5 "install worker"
         6 "install swarm"
         7 "registering portainer")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)


case $CHOICE in
        1)
            chmod a+x playbook/installansible.sh
            playbook/installansible.sh
            cp -f ./hosts /etc/ansible/hosts
            ;;
        2)
            cp -f ./hosts /etc/ansible/hosts
            echo " update file hosts complete!!!"
            ;;
        3)
            ansible-playbook playbook/umanager.yml
            ;;
        4)
            ansible-playbook playbook/managerjoin.yml
            ;;
        5)
            ansible-playbook playbook/workerjoin.yml
            ;;
        6)
            ansible-playbook playbook/umanager.yml
            ansible-playbook playbook/umanager.yml --tags dkp
            ansible-playbook playbook/managerjoin.yml
            ansible-playbook playbook/workerjoin.yml            
            ;;
        7)
            ansible-playbook playbook/umanager.yml --tags dkp
esac