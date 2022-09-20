#!/bin/bash

HEIGHT=20
WIDTH=60
CHOICE_HEIGHT=10
BACKTITLE="Install with ansible"
TITLE="Install swarm"
MENU="Choose one of the following options:"

function installansible() {
	{
    	apt install python3-pip -y
        pip3 install ansible
        mkdir -p /etc/ansible/
        printf '
        [leader]
        ansible ansible_host=192.168.253.140 ansible_port=22 ansible_user=root

        [reachable]
        ubuntu202 ansible_host=192.168.253.139 ansible_port=22 ansible_user=root

        [worker]
        ubuntu201 ansible_host=192.168.253.138 ansible_port=22 ansible_user=root
        ' > /etc/ansible/hosts
	}
}

function copykeygen()
{   
    for ip in `cat server.txt`; do
        ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 $ip
    done
}
function listserver()
{   
    dialog --title "Server list" --backtitle "Title" --editbox server.txt 20 50 2>>server.txt
}
function insertpass()
{   
    dialog --inputbox "Password" 40 40 2> password.txt
}

function submenu()
{
    while [ 1 ]
    OPTIONS=(
         1 "install multi-manage multi-worker cluster"
         2 "install manager leader *"
         3 "install manager reachable"
         4 "install worker"
         0 "reload menu"
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
                ansible-playbook playbook/umanager.yml
                ansible-playbook playbook/managerjoin.yml
                ansible-playbook playbook/workerjoin.yml            
                ;;
            2)
                ansible-playbook playbook/umanager.yml
                ;;
            3)
                ansible-playbook playbook/managerjoin.yml
                ;;
            4)
                ansible-playbook playbook/workerjoin.yml
                ;;
            0)
                ./start
    esac
    done
}

OPTIONS=(1 "install ansible"
         2 "Copy keygen ssh"
         3 "update file hosts --> /etc/ansible/hosts"
         4 "Cập nhật file variables.yml"
         5 "install swarm server"
         6 "install swarm cluster only one node"
         7 "install portainer"
         8 "install infrastructure + instaii traefik"
         0 "reload menu"
)

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        1)
            installansible
            < /dev/zero ssh-keygen -q -N ""
			dialog --msgbox "install ansible complete!!!" 20 78
            ;;
        2)
            nano server.txt
#            listserver
#            insertpass
            copykeygen
            ;;
        3)
            nano hosts
            cp -f ./hosts /etc/ansible/hosts | dialog --title "Gauge" --gauge "Wait please..." 10 60 0
			dialog --msgbox "update file hosts complete!!!" 20 78
            ;;
        4)
            nano playbook/variables.yml;;
        5)
            submenu
            ;;
        6)
            ansible-playbook playbook/umanager.yml
            ansible-playbook playbook/git.yml
            ansible-playbook playbook/portainerinstall.yml --skip-tags git
            ansible-playbook playbook/traefikinstall.yml --skip-tags git
            ansible-playbook playbook/infrainstall.yml --skip-tags git
            ;;
        7)
            ansible-playbook playbook/portainerinstall.yml
            ;;
        8)
            ansible-playbook playbook/traefikinstall.yml
            ansible-playbook playbook/infrainstall.yml
            ;;
        9)
            ansible-playbook playbook/infrainstall.yml
            ;;
        0)
            ./start
esac

exit 0