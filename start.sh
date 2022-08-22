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
	}
}
function UpdateAndUpgrade()
{
    DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
    DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade

    apt-get autoremove -y
    apt-get clean
    apt-get autoclean
}
function copykeygen()
{   
    sudo apt-get install -y sshpass
    for ip in `cat server.txt`; do
        sshpass -f password.txt ssh-copy-id -i ~/.ssh/id_rsa.pub -p 2239 $ip
    done
}
function insertpass()
{   
    kdialog --title "passwd" --inputbox "mat khau" > password.txt
}

while [ 1 ]
OPTIONS=(1 "install ansible"
         2 "Copy keygen ssh"
         3 "update file hosts --> /etc/ansible/hosts"
         4 "Cập nhật file variables.yml"
         5 "install manager leader *"
         6 "install manager reachable"
         7 "install worker"
         8 "install swarm"
)

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

do
case $CHOICE in
        1)
            installansible
            < /dev/zero ssh-keygen -q -N ""
			dialog --msgbox "install ansible complete!!!" 20 78
            ;;
        2)
            nano server.txt
            insertpass
            copykeygen;;
        3)
            nano hosts
            cp -f ./hosts /etc/ansible/hosts | dialog --title "Gauge" --gauge "Wait please..." 10 60 0
			dialog --msgbox "update file hosts complete!!!" 20 78
            ;;
        4)
            nano playbook/variables.yml;;
        5)
            ansible-playbook playbook/umanager.yml
            ;;
        6)
            ansible-playbook playbook/managerjoin.yml
            ;;
        7)
            ansible-playbook playbook/umanager.yml --tags token
            ansible-playbook playbook/workerjoin.yml
            ;;
        8)
            ansible-playbook playbook/umanager.yml
            ansible-playbook playbook/umanager.yml --tags dkp
            ansible-playbook playbook/managerjoin.yml
            ansible-playbook playbook/workerjoin.yml            
            ;;
        0)
            ./start
esac
done
exit 0