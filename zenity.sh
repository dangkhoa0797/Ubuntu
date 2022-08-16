#!/bin/bash
apt-get install -y zenity

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

menu=`zenity --list --title="WHATEVER Options" --column="0" "Install ansible" "update file hosts --> /etc/ansible/hosts" "Install swarm" "Refresh menu" --width=600 --height=300 --hide-header`

if [ "$menu" == "Install ansible" ]; then
    installansible
    ./start.sh
fi

if [ "$menu" == "update file hosts --> /etc/ansible/hosts" ]; then
    cp -f ./hosts /etc/ansible/hosts
    ./start.sh
fi

if [ "$menu" == "Install swarm" ]; then
    ansible-playbook playbook/umanager.yml
    ansible-playbook playbook/umanager.yml --tags dkp
    ansible-playbook playbook/managerjoin.yml
    ansible-playbook playbook/workerjoin.yml
    ./start.sh
fi

if [ "$menu" == "Refresh menu" ]; then
    ./start.sh
fi
exit 0