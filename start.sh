#!/bin/bash

sudo apt-get install dialog
HEIGHT=20
WIDTH=60
CHOICE_HEIGHT=7
BACKTITLE="Install with ansible"
TITLE="Install swarm"
MENU="Choose one of the following options:"

function installansible() {
	{
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
	} | dialog --title "Gauge" --gauge "Wait please..." 10 60 0
}

function UpdateAndUpgrade()
{
    DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
    DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade

    apt-get autoremove -y
    apt-get clean
    apt-get autoclean
}

while [ 1 ]
do
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
            UpdateAndUpgrade
            installansible
            < /dev/zero ssh-keygen -q -N ""
			dialog --msgbox "install ansible complete!!!" 20 78
            ./start
            ;;
        2)
            cp -f ./hosts /etc/ansible/hosts | dialog --title "Gauge" --gauge "Wait please..." 10 60 0
			dialog --msgbox "update file hosts complete!!!" 20 78
            ./start
            ;;
        3)
            ansible-playbook playbook/umanager.yml | dialog --title "Gauge" --gauge "Wait please..." 10 60 0
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
exit
done
