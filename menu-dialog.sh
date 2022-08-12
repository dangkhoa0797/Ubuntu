#!/bin/bash
#sudo apt-get install dialog
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Install with ansible"
TITLE="Install swarm"
MENU="Choose one of the following options:"

OPTIONS=(1 "install manager leader"
         2 "install manager reachable"
         3 "install worker")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            ansible-playbook umanager.yml
            ;;
        2)
            ansible-playbook managerjoin.yml
            ;;
        3)
            ansible-playbook workerjoin.yml
            ;;
esac