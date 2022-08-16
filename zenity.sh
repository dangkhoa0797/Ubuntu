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

menu=`zenity --list --title="Danh sách cài đặt" --column="0" "Cài đặt ansible" "Cập nhật file hosts --> /etc/ansible/hosts" "Cài đặt swarm" "Tải lại menu" --width=600 --height=300 --hide-header  --text="Chọn một nhiệm vụ"`

if [ "$menu" == "Cài đặt ansible" ]; then
    installansible
    ./start.sh
fi

if [ "$menu" == "Cập nhật file hosts --> /etc/ansible/hosts" ]; then
    cp -f ./hosts /etc/ansible/hosts
    ./start.sh
fi

if [ "$menu" == "Cài đặt swarm" ]; then
    ansible-playbook playbook/umanager.yml
    ansible-playbook playbook/umanager.yml --tags dkp
    ansible-playbook playbook/managerjoin.yml
    ansible-playbook playbook/workerjoin.yml
    ./start.sh
fi

if [ "$menu" == "Tải lại menu" ]; then
    ./start.sh
fi
exit 0
# Nhấn Esc để đóng