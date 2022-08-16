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

menu=`zenity --list --width=800 --height=400 \
--title="Danh sách cài đặt" \
--text='<span foreground="pink" font="26">Chọn một nhiệm vụ.\n</span>' \
  --column="Số thứ tự" --column="Lệnh" --column="Ghi chú" \
    1 "Cài đặt ansible" k \
    2 "Cập nhật file hosts --> /etc/ansible/hosts" k\
    3 "Cài đặt swarm" k\
    4 "Tải lại menu" k

     `

if [ "$menu" == "1" ]; then
    installansible 
    ./start.sh
fi

if [ "$menu" == "2" ]; then
    cp -f ./hosts /etc/ansible/hosts
    ./start.sh
fi

if [ "$menu" == "3" ]; then
    ansible-playbook playbook/umanager.yml
    ansible-playbook playbook/umanager.yml --tags dkp
    ansible-playbook playbook/managerjoin.yml
    ansible-playbook playbook/workerjoin.yml
    ./start.sh
fi

if [ "$menu" == "4" ]; then
    ./start.sh
fi
exit 0
# Nhấn Esc để đóng